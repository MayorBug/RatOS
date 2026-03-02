# Filament Sensors

RatOS supports multiple sensor types that are toolhead-aware. These sensors can be combined to work together. Configure them as described - no other changes are needed.

When combining toolhead and bowden sensors, each sensor has a specific function. The toolhead sensor handles insert detection while the bowden sensor is responsible for runout detection. This has the benefit that you don't need to open a heated chamber and remove the bowden tube to remove old filament - it will be ejected and can be easily removed at the end of the bowden tube.

:::info
Sensors can be temporarily deactivated in the Mainsail user interface.
:::

:::info
If a sensor shows "detected" when no filament is loaded and "empty" when filament is loaded, invert the `switch_pin` by adding or removing a `!` in front of the pin name. The sensor state will be displayed in the Mainsail user interface.
:::

## Supported Sensors

- [Toolhead Filament Sensor](#toolhead-filament-sensor)
- [Bowden Filament Sensor](#bowden-filament-sensor)
- [Motion Filament Sensor](#motion-filament-sensor)
- [Action Button](#action-button)

## RatOS Configuration

- [Sensor features](#sensor-features)
- [Filament grabbing](#filament-grabbing)
- [Purging](#purging)
- [Feedrates](#feedrates)
- [Retraction](#retraction)
- [Advanced](#advanced)

## Toolhead Filament Sensor

Toolhead filament sensors attach directly to the toolhead.

### Features

- Runout detection
- Insert detection
- Automatic filament loading on insert
- Automatic filament unloading after runout
- Automatic print resume after insert
- Spool joining for IDEX printers
- Filament grabbing on insert
- Filament presence/runout check before starting a print
- Frontend toolhead color status display

### Configuration

```
[filament_switch_sensor toolhead_filament_sensor_t0]
pause_on_runout: False
event_delay: 0.1
switch_pin: ^!toolboard_t0:PB3
runout_gcode:
    _ON_TOOLHEAD_FILAMENT_SENSOR_RUNOUT TOOLHEAD=0
insert_gcode:
    _ON_TOOLHEAD_FILAMENT_SENSOR_INSERT TOOLHEAD=0
```

## Bowden Filament Sensor

Bowden filament sensors attach somewhere along the bowden tube.

### Features

- Runout detection
- Insert detection (no automatic action available, macro can be overridden)
- Automatic filament unloading after runout
- Spool joining for IDEX printers
- Filament presence/runout check before starting a print
- Frontend toolhead color status display

### Configuration

```
[filament_switch_sensor bowden_filament_sensor_t0]
pause_on_runout: False
event_delay: 0.1
switch_pin: ^!PC15
runout_gcode:
    _ON_BOWDEN_FILAMENT_SENSOR_RUNOUT TOOLHEAD=0
insert_gcode:
    _ON_BOWDEN_FILAMENT_SENSOR_INSERT TOOLHEAD=0
```

## Motion Filament Sensor

Motion sensors can detect filament clogs.

### Features

- Optional runout detection
- Optional insert detection (no automatic action available, macro can be overridden)
- Clog detection
- Automatic filament unloading after runout
- Spool joining for IDEX printers

### Configuration

```
[filament_motion_sensor bowden_filament_clog_t0]
switch_pin: ^PG15
detection_length: 8
extruder: extruder   # extruder for T0, extruder1 for T1
pause_on_runout: False
event_delay: 3.0
pause_delay: 0.5
runout_gcode:
  _ON_BOWDEN_FILAMENT_SENSOR_CLOG TOOLHEAD=0
insert_gcode:
```

## Action Button

Some filament sensors, like the Orbiter filament sensor, come with an action button.

### Features

- Filament unload

### Configuration

```
[gcode_button toolhead_filament_sensor_button_t0]
pin: ^!toolboard_t0:PB4
release_gcode:
  _ON_FILAMENT_SENSOR_BUTTON_PRESSED TOOLHEAD=0
press_gcode:
```

## Orbiter Smart Filament Sensor example configuration

The new Orbiter Smart Filament Sensor with filament tangle detection.

```
[filament_switch_sensor toolhead_filament_sensor_t0]
pause_on_runout: False
event_delay: 0.1
switch_pin: ^PA13
runout_gcode:
    _ON_TOOLHEAD_FILAMENT_SENSOR_RUNOUT TOOLHEAD=0
insert_gcode:
    _ON_TOOLHEAD_FILAMENT_SENSOR_INSERT TOOLHEAD=0

[gcode_button toolhead_filament_sensor_button_t0]
pin: ^PA14
release_gcode:
    {% if (printer.print_stats.state == "printing") %}
            _ON_TOOLHEAD_FILAMENT_SENSOR_CLOG TOOLHEAD=0
    {% else %}
            _ON_FILAMENT_SENSOR_BUTTON_PRESSED TOOLHEAD=0
    {% endif %}
press_gcode:
```

## RatOS Configuration

### Sensor features

```
[gcode_macro T0]
variable_enable_insert_detection: True     # enables the insert detection
variable_enable_runout_detection: True     # enables the runout detection
variable_enable_clog_detection: True       # enables the clog detection
variable_unload_after_runout: True         # unload filament after runout has been detected
variable_resume_after_insert: True         # resumes the print after inserting new filament
```

### Filament grabbing

When inserting a filament into the toolhead filament sensor, the extruder gears will grab the filament, even if the hotend is still cold.

```
[gcode_macro T0]
variable_filament_grabbing_speed: 1     # filament grabbing speed in mm/s
variable_filament_grabbing_length: 5    # filament grabbing length in mm
```

### Purging

```
[gcode_macro T0]
variable_purge_after_load: 30      # purge x mm after the filament has been loaded to the nozzle tip
variable_purge_before_unload: 0    # purge x mm before the filament unloads
```

### Feedrates

```
[gcode_macro T0]
variable_filament_load_speed: 10   # filament nozzle loading speed
variable_extruder_load_speed: 60   # extruder/cooling zone loading speed
```

### Retraction

```
[gcode_macro PAUSE]
variable_retract: 1.5   # retract on pause print
variable_extrude: 1.5   # extrude before resume print
```

### Parking Position

```
[gcode_macro RatOS]
variable_runout_park_in: "front"   # back|front|center = gantry parking position if a runout or clog has been detected
variable_runout_park_x: 50         # float = if configured the x position of the toolhead. if not configured it will park in the middle
```

### Advanced

```
[gcode_macro T0]
variable_cooling_position_to_nozzle_distance: 40            # distance between the cooling position and the nozzle
variable_tooolhead_sensor_to_extruder_gear_distance: 15     # distance between the filament sensor trigger point
                                                            # and where the filament hits the extruder gears
variable_extruder_gear_to_cooling_position_distance: 30     # distance between the extruder gears and the center of the heatsink cooling tube
variable_filament_loading_nozzle_offset: -10                # offset tuning value. positive or negative number.
                                                            # different nozzles can lead to too much or not enough extrusion while loading the filament
```
