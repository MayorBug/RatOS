# LED Control

RatOS includes built-in LED status control for toolhead LEDs and supports additional custom LED configurations.

## Toolhead LED Configuration

### Single Toolhead Printer

Configure your LED with the name `nozzle_led_t0`:

```
[neopixel nozzle_led_t0]
pin: toolboard_t0:PD3
chain_count: 3
color_order: GRB
initial_RED: 1.0
initial_GREEN: 1.0
initial_BLUE: 1.0
```

### IDEX Printer

Configure your LEDs with names `nozzle_led_t0` and `nozzle_led_t1`:

```
[neopixel nozzle_led_t0]
pin: toolboard_t0:PD3
chain_count: 3
color_order: GRB
initial_RED: 1.0
initial_GREEN: 1.0
initial_BLUE: 1.0

[neopixel nozzle_led_t1]
pin: toolboard_t1:PD3
chain_count: 3
color_order: GRB
initial_RED: 1.0
initial_GREEN: 1.0
initial_BLUE: 1.0
```

## Custom LED Integration

To add a custom LED to RatOS LED control, configure it according to Klipper documentation and override this macro in your printer.cfg:

```
[gcode_macro _USER_LED_SET]
gcode:
    # Parameters
    {% set toolhead = params.TOOLHEAD|default(-1)|int %}
    {% set r = params.R|default(0)|float %}
    {% set g = params.G|default(0)|float %}
    {% set b = params.B|default(0)|float %}

    # Replace MY_LED_NAME with your custom LED name
    SET_LED LED="MY_LED_NAME" RED={r} GREEN={g} BLUE={b} SYNC=0
```

## Status Colors

Customize LED status colors by overriding these RGB values in your printer.cfg:

```
[gcode_macro RatOS]
variable_led_status_action:    0.0, 1.0, 1.0
variable_led_status_success:   0.0, 1.0, 0.0
variable_led_status_error:     1.0, 0.0, 1.0
variable_led_status_on:        1.0, 1.0, 1.0
variable_led_status_off:       0.0, 0.0, 1.0
variable_led_status_standby:   0.1, 0.1, 0.1
```
