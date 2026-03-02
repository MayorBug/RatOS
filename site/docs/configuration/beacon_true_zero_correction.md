# Beacon True Zero Correction

:::warning Using Damaged Build Sheets
Do not use beacon true zero (with or without the correction feature) with a build sheet with significant damage around the safe home position (by default, the middle of the sheet). If an area with missing coating is probed, true zero can be set to a Z height that is significantly lower than the actual coating surface, which can lead to nozzle crashes and further damage to the build sheet.
:::

RatOS extends the beacon contact `BEACON_AUTO_CALIBRATE` command with a true zero correction feature via the `[beacon_true_zero_correction]` module. This feature is also known as _multipoint probing_ or _multipoint true zero_.

## Background

Following an extensive investigation, we found that while contact measurements at the same location are very repeatable, measuring neigbouring points (on a 1mm grid) can yield a result that in some cases differs by up to 100 microns (0.1mm). When used for true zero, this close proximity positional variablilty of contact readings is enough to have a significant impact on first layer consistency: a small difference in build sheet position or toolhead homing can lead to an effectively arbitrary true zero difference that is approaching 50% of a 0.2mm first layer.

Based on analysis of thousands of test data points, we determined that by applying a particular statistical method to six additional single-dive probes of randomly-positioned points in close proximity to the nominal true zero position, we could determine a correction value that significantly reduces the range of variability, with no negative impact for inherently low-variability build sheets. Also of note was the observation that the variabilty has some correlation to surface roughness, with textured surfaces generally showing more variability than smooth surfaces. Further, we saw the greatest variation on brand new textured PEI build sheets, and that variability appears to reduce as the sheet gets more use.

## Configuration

The `[beacon_true_zero_correction]` module is enabled by default in RatOS whenever a beacon probe is configured in the setup wizard. You should not add anything to your `printer.cfg` unless you want to disable the true zero correction feature.

### Disabling True Zero Correction
 Add the following to `printer.cfg`:

```properties
[beacon_true_zero_correction]
disabled: True        
```