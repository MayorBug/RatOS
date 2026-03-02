---
sidebar_label: Initial Configuration
sidebar_position: 2
---

# Configuring RatOS

:::warning 2.1 documentation is incomplete.
This is preliminary documentation for the upcoming v2.1.0 release. The work is still ongoing and the documentation is not yet complete.
:::

RatOS only needs minimal configuration to work, but comes with a lot of optional functionality that you can enable manually.

## Introduction

Once you have completed the initial [setup](installation) and opened [http://RatOS.local/](http://RatOS.local/) in your browser, you are almost ready to print. There's a just a few things to go over to make sure everything is working correctly.

## Initial Configuration

1. Open `printer.cfg`

Navigate to the `Machine` page in Mainsail (the webinterface you just opened in your browser), there's a list of files, among them is `printer.cfg`. Right click it and choose "Edit".

This is where your personal klipper configuration lives. As you can see, it's prepopulated with the most common settings you may want to tweak or change. At the very top you'll see `[include RatOS.cfg]`, this is all of the configurationn that RatOS generated for you. Everything below that line is your personal configuration, and you can edit it to your liking.

Everything you write in printer.cfg will add to or override the RatOS defaults. **You should never edit the RatOS.cfg file**, as this will be overwritten when you update RatOS.

2. Follow the instructions in printer.cfg if any are present, to complete any additional setup steps.

:::info Are you still getting errors?
If you're getting errors after going through printer.cfg, you either messed up the syntax (like, missing a `[section header]`), or your wiring isn't correct. If you get any MCU errors, turn off your MCU and go over your wiring again, you may be shorting something. **You already verified that your board is working and connecting when you flashed it in the RatOS configurator**.
:::

## Verify Stepper Directions

You should make sure your steppers are running in the correct direction.

1. Center kinematic positioning

To do this, center all your axes by moving the carriage and bed manually, then type `SET_CENTER_KINEMATIC_POSITION` in the console. You can now use the Mainsail controls to move the axes.

2. Verify Z direction

By default, the Z controls in the Mainsail interface will increase Z when you click the up arrow. This will lower the bed on a CoreXY machine with a moving bed such as the V-Core 3, and raise the X gantry on a bedslinger such as the V-Minion or V-Cast.

If your bed does not move down (or your x gantry doesn't raise) when you click the up arrow, change the direction of your Z steppers in printer.cfg. There's instructions on how to do that in the `[stepper_z]` sections in printer.cfg.

3. Verify X and Y direction

Check the front/back and left/right directions by clicking the corresponding arrows in the Mainsail interface.

If your toolhead does not move in the direction the arrows are pointing, change the direction of your X and Y steppers in `printer.cfg` accordingly.
There are instructions on how to do that in the `[stepper_x]` and `[stepper_y]` sections in `printer.cfg`.

On CoreXY printers, both the X and Y stepper are used for movement in both directions, if you change the direction of one, it will change the movement of both axes.

:::info
If you want to invert the Z behavior in the Mainsail interface (ie. making the bed move down when you click the down arrow), click the cogs (settings) in the upper right part of the interface, then "control", and then enable "Invert Z Control". This will **NOT** change your stepper directions, it will only change what gcode the buttons execute.
:::

## Verify Endstops and Z-Probe

Let's veryify that your endstops and Z-Probe are working correctly.

1. Verify endstops

<div className="text-amber-300 font-medium">
_Skip this step if you're using sensorless homing, see the instructions in `printer.cfg`_
</div>

Navigate to the Machine tab. In here you can see your endstop state. Refresh the endstop state and verify that all endstops are open, and that the state changes to triggered when you manually trigger the endstops refresh the endstop state.

If the state does not change or does not reflect the correct state, you should double check your wiring.

2. Verify Z-Probe

<div className="text-amber-300 font-medium">
_Skip this step if you're using a Beacon, see the instructions in `printer.cfg`_
</div>

In the same dialog, you can also see your Z-Probe state. Refresh the Z-Probe state and verify that the state changes to triggered when you manually trigger the Z-Probe.

If the probe does not trigger, you should double check your wiring and whether you've selected the correct probe in the hardware configuration step of the RatOS configurator wizard.

:::info
To test, debug and/or verify a BLTouch, refer to the [BLTouch klipper documentation](https://www.klipper3d.org/BLTouch.html)
:::

## Z-Offset

<div className="text-amber-300 font-medium">
_Skip this step if you're using a Beacon, see the instructions in `printer.cfg`_
</div>

1. Run `PROBE_CALIBRATE`

Click the text input in the console panel and trype `PROBE_CALIBRATE` and hit enter, read more in the [klipper probe z-offset calibration documentation](https://www.klipper3d.org/Probe_Calibrate.html#calibrating-probe-z-offset).

You should also refer to the [klipper probe X/Y calibration documentation](https://www.klipper3d.org/Probe_Calibrate.html#calibrating-probe-x-and-y-offsets) in case you use a non EVA standard toolhead or have any modifications to your probe, which might need a different probe X/Y offset than the RatOS defaults.

:::warning
If you're using a non Rat Rig printer, you should always calibrate your probe's x/y offset, refer to the [klipper probe calibration documentation](https://www.klipper3d.org/Probe_Calibrate.html#calibrating-probe-x-and-y-offsets).
:::

:::info
The Z-Offset is the distance in Z between your probe's trigger point and your nozzle in gcode space. This is typically within 0-4mm.
:::

## Tuning

When you've verified that everything works, and you have your [slicer configured](slicers) to use the `START_PRINT` and `END_PRINT` macros, you can now start tuning. Refer to the klipper documentation for:

- [PID Tuning](https://www.klipper3d.org/Config_checks.html#calibrate-pid-settings)
- [Pressure Advance tuning](https://www.klipper3d.org/Pressure_Advance.html)
- [manual Input Shaper calibration](https://www.klipper3d.org/Resonance_Compensation.html) or [Input Shaper calibration via an ADXL345](https://www.klipper3d.org/Measuring_Resonances.html)
- [Skew Correction](https://www.klipper3d.org/Skew_Correction.html)

## Testing accelerometers

If you're using an accelerometer for automatic input shaper calibration, you can test it by running `MEASURE_AXES_NOISE` in the Mainsail console. If the values are below 100, you're good to go. If you're using a CoreXY machine, you may find the `MEASURE_COREXY_BELT_TENSION` macro handy for checking if your belts are equally tensioned (the peaks in the resulting graphs should line up with each other).

For all printers with an ADXL345 you can use `GENERATE_SHAPER_GRAPHS` to run resonance tests and generate resonance graphs for analysis of your printers resonance profile, use this to manually pick the best parameters for your printer configuration. To calibrate input shaper automatically, write `SHAPER_CALIBRATE` in the console, this will run the resonances tests and automatically guess the parameters which can then be saved via `SAVE_CONFIG`.

RatOS aliases all automatically configured accelerometers, which means you need to supply the correct type and name of the accelerometer in the accelerometer specific gcode commands such as `ACCELEROMETER_QUERY`.

- An accelerometer connected to the main control board is aliased as `controlboard`
- An accelerometer integrated on the toolboard of the main toolhead is aliased as `toolboard_t0`
- An accelerometer integrated on the toolboard of the secondary toolhead is aliased as `toolboard_t1`
- An accelerometer connected to the Raspberry Pi is aliased as `rpi`
- The accelerometer integrated in the Beacon Rev H is aliased as `beacon` and has the type `beacon`

Examples:

- `ACCELEROMETER_QUERY CHIP="adxl345 controlboard"`
- `ACCELEROMETER_QUERY CHIP="lis2dw toolboard_t0"`
- `ACCELEROMETER_QUERY CHIP="beacon beacon"`

### USB Accelerometers

If you're using a self-maintained USB accelerometer, it is important that you name the `[mcu]` section as well as the `[adxl345]` or `[lis2dw]` section with a unique name. Further more, if you want to add an override to make `[resonance_tester]` use your USB accelerometer, you need to override both `accel_chip_x` and `accel_chip_y` by adding or modifying the `[resonance_tester]` section in `printer.cfg`.

Example:

```properties
[mcu my_usb_accelerometer]
# ...

[adxl345 my_adxl345_accelerometer]
mcu: my_usb_accelerometer
# ...

[lis2dw my_lis2dw_accelerometer]
mcu: my_usb_accelerometer
# ...

[resonance_tester]
accel_chip_x: adxl345 my_adxl345_accelerometer
accel_chip_y: lis2dw my_lis2dw_accelerometer
```

### Realtime Analysis Tool

The Realtime Analysis Tool is a tool that allows you to analyze the resonance of your printer in realtime. Read more about it in the [Realtime Analysis Tool guide](/docs/guides/real-time-analysis).
