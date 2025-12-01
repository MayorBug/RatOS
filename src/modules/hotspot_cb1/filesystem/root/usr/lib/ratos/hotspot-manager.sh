#!/usr/bin/env bash
set -euo pipefail
LANG=C

CONFIG_PATH="/boot/hotspot.cfg"
DEFAULT_CONFIG="/usr/share/ratos/hotspot.cfg"
HOTSPOT_CONNECTION_NAME="RatOS Hotspot"
CLIENT_CONNECTION_NAME="RatOS WiFi"

log() {
    echo "[hotspot-manager] $*"
}

bool_true() {
    local value="${1:-0}"
    case "${value,,}" in
        1|true|yes|y|on|enable|enabled) return 0 ;;
        *) return 1 ;;
    esac
}

to_yes_no() {
    if bool_true "$1"; then
        echo "yes"
    else
        echo "no"
    fi
}

ensure_config() {
    if [[ ! -f "${CONFIG_PATH}" ]]; then
        if [[ -f "${DEFAULT_CONFIG}" ]]; then
            install -D -m 600 "${DEFAULT_CONFIG}" "${CONFIG_PATH}"
            log "Created default ${CONFIG_PATH}"
        else
            log "ERROR: ${CONFIG_PATH} missing and no default available"
            exit 1
        fi
    fi
}

load_config() {
    ensure_config
    # defaults
    HOTSPOT_ENABLED=1
    HOTSPOT_INTERFACE="wlan0"
    HOTSPOT_SSID="RatOS"
    HOTSPOT_PASSPHRASE="raspberry"
    HOTSPOT_CHANNEL=6
    HOTSPOT_BAND="bg"
    HOTSPOT_ADDRESS="192.168.50.1/24"
    HOTSPOT_COUNTRY=""
    WIFI_SSID=""
    WIFI_PASSPHRASE=""
    LAN_INTERFACES="eth0"
    AUTOSTOP_ON_WIFI=1
    AUTOSTOP_ON_LAN=1

    # shellcheck disable=SC1090
    source "${CONFIG_PATH}"

    WIFI_DEVICE="${HOTSPOT_INTERFACE:-wlan0}"
    if [[ "${WIFI_DEVICE}" == "auto" || ! -d "/sys/class/net/${WIFI_DEVICE}" ]]; then
        WIFI_DEVICE="$(nmcli -t -f DEVICE,TYPE device status 2>/dev/null | awk -F: '$2=="wifi"{print $1; exit}')"
        WIFI_DEVICE="${WIFI_DEVICE:-wlan0}"
    fi

    LAN_INTERFACES="${LAN_INTERFACES//,/ }"
}

nm_connection_exists() {
    local name="$1"
    nmcli -t -f NAME connection show | grep -Fxq "${name}"
}

ensure_hotspot_connection() {
    local gateway="${HOTSPOT_ADDRESS%%/*}"

    if ! nm_connection_exists "${HOTSPOT_CONNECTION_NAME}"; then
        nmcli connection add type wifi ifname "${WIFI_DEVICE}" mode ap con-name "${HOTSPOT_CONNECTION_NAME}" ssid "${HOTSPOT_SSID}"
    fi

    if [[ ${#HOTSPOT_PASSPHRASE} -lt 8 ]]; then
        log "ERROR: HOTSPOT_PASSPHRASE must be at least 8 characters"
        exit 1
    fi

    nmcli connection modify "${HOTSPOT_CONNECTION_NAME}" \
        connection.autoconnect "$(to_yes_no "${HOTSPOT_ENABLED}")" \
        connection.autoconnect-priority -999 \
        connection.interface-name "${WIFI_DEVICE}" \
        802-11-wireless.mode ap \
        802-11-wireless.ssid "${HOTSPOT_SSID}" \
        ipv4.method shared \
        ipv4.addresses "${HOTSPOT_ADDRESS}" \
        ipv4.gateway "${gateway}" \
        ipv4.dns "8.8.8.8,1.1.1.1" \
        ipv4.may-fail no \
        ipv6.method ignore \
        802-11-wireless-security.key-mgmt wpa-psk \
        802-11-wireless-security.psk "${HOTSPOT_PASSPHRASE}"

    if [[ -n "${HOTSPOT_BAND:-}" ]]; then
        nmcli connection modify "${HOTSPOT_CONNECTION_NAME}" 802-11-wireless.band "${HOTSPOT_BAND}"
    fi

    if [[ -n "${HOTSPOT_CHANNEL:-}" && "${HOTSPOT_CHANNEL}" != "auto" ]]; then
        nmcli connection modify "${HOTSPOT_CONNECTION_NAME}" 802-11-wireless.channel "${HOTSPOT_CHANNEL}"
    else
        nmcli connection modify "${HOTSPOT_CONNECTION_NAME}" 802-11-wireless.channel ""
    fi
}

ensure_client_connection() {
    if [[ -z "${WIFI_SSID}" ]]; then
        if nm_connection_exists "${CLIENT_CONNECTION_NAME}"; then
            nmcli connection modify "${CLIENT_CONNECTION_NAME}" connection.autoconnect no
        fi
        return
    fi

    if ! nm_connection_exists "${CLIENT_CONNECTION_NAME}"; then
        nmcli connection add type wifi ifname "${WIFI_DEVICE}" con-name "${CLIENT_CONNECTION_NAME}" ssid "${WIFI_SSID}"
    fi

    nmcli connection modify "${CLIENT_CONNECTION_NAME}" \
        connection.autoconnect yes \
        connection.autoconnect-priority 100 \
        connection.interface-name "${WIFI_DEVICE}" \
        802-11-wireless.mode infrastructure \
        802-11-wireless.ssid "${WIFI_SSID}" \
        ipv4.method auto \
        ipv6.method auto

    if [[ -n "${WIFI_PASSPHRASE}" ]]; then
        if [[ ${#WIFI_PASSPHRASE} -lt 8 ]]; then
            log "WARNING: WIFI_PASSPHRASE is shorter than 8 characters; treating network as open"
            nmcli connection modify "${CLIENT_CONNECTION_NAME}" 802-11-wireless-security.key-mgmt none
            nmcli connection modify "${CLIENT_CONNECTION_NAME}" -802-11-wireless-security.psk || true
        else
            nmcli connection modify "${CLIENT_CONNECTION_NAME}" 802-11-wireless-security.key-mgmt wpa-psk
            nmcli connection modify "${CLIENT_CONNECTION_NAME}" 802-11-wireless-security.psk "${WIFI_PASSPHRASE}"
        fi
    else
        nmcli connection modify "${CLIENT_CONNECTION_NAME}" 802-11-wireless-security.key-mgmt none
        nmcli connection modify "${CLIENT_CONNECTION_NAME}" -802-11-wireless-security.psk || true
    fi
}

lan_connected() {
    local targets=()
    read -ra targets <<<"${LAN_INTERFACES}"
    if [[ "${#targets[@]}" -eq 0 ]]; then
        targets=("eth0")
    fi
    while IFS=: read -r iface state; do
        for target in "${targets[@]}"; do
            if [[ "${iface}" == "${target}" && "${state}" == "connected" ]]; then
                return 0
            fi
        done
    done < <(nmcli -t -f DEVICE,STATE device status 2>/dev/null || true)
    return 1
}

wifi_client_connected() {
    local name type dev
    while IFS=: read -r name type dev; do
        [[ -z "${name}" ]] && continue
        if [[ "${type}" == "802-11-wireless" && "${dev}" == "${WIFI_DEVICE}" && "${name}" != "${HOTSPOT_CONNECTION_NAME}" ]]; then
            return 0
        fi
    done < <(nmcli -t -f NAME,TYPE,DEVICE connection show --active 2>/dev/null || true)
    return 1
}

hotspot_should_run() {
    bool_true "${HOTSPOT_ENABLED}" || return 1
    if bool_true "${AUTOSTOP_ON_WIFI}" && wifi_client_connected; then
        return 1
    fi
    if bool_true "${AUTOSTOP_ON_LAN}" && lan_connected; then
        return 1
    fi
    return 0
}

bring_hotspot_up() {
    nmcli connection up "${HOTSPOT_CONNECTION_NAME}" >/dev/null 2>&1 || true
}

bring_hotspot_down() {
    nmcli connection down "${HOTSPOT_CONNECTION_NAME}" >/dev/null 2>&1 || true
}

apply_state() {
    if hotspot_should_run; then
        bring_hotspot_up
    else
        bring_hotspot_down
    fi
}

apply_config() {
    command -v nmcli >/dev/null 2>&1 || { log "nmcli not found"; exit 1; }
    load_config

    if [[ -n "${HOTSPOT_COUNTRY}" ]]; then
        iw reg set "${HOTSPOT_COUNTRY}" >/dev/null 2>&1 || true
    fi

    ensure_hotspot_connection
    ensure_client_connection
    apply_state
}

handle_event() {
    local iface="${1:-}"
    local action="${2:-}"

    load_config

    # Avoid acting on our own AP interface state changes beyond enforcing policy.
    case "${action}" in
        up|down|vpn-up|vpn-down)
            ;;
        *)
            # ignore pre-up/post-down and dhcp4-change noise
            return 0
            ;;
    esac

    apply_state
}

main() {
    local cmd="apply"
    if [[ $# -gt 0 ]]; then
        cmd="$1"
        shift
    fi
    case "${cmd}" in
        apply)
            apply_config
            ;;
        event)
            handle_event "$@"
            ;;
        *)
            echo "Usage: hotspot-manager.sh [apply|event <iface> <action>]" >&2
            exit 1
            ;;
    esac
}

main "$@"
