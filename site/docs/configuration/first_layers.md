# First Layers

:::info
This is preliminary documentation
:::
## Beacon True Zero and other high Z accuracy setups
RatOS 2.1.0-RC4 introduces significant improvements to the Beacon True Zero calibration and compensation system, greatly improving first layer accuracy and consistency. Particularly when combined with a thermally-stable gantry construction, such as the steel tube gantry of the Rat Rig V-Core 4.1, this allows for extremely accurate and consistent first layers. Long-held instincts about diagnosing and tuning first layers may need to be re-evaluated in light of these improvements.

When describing the appearance of a first layer, it is reccommended to avoid the terms like "too high", "too low", "under-squished" and "over-squished" as these terms presume that nozzle height is the primary cause. Instead, it is recommended to use terms that descrive the physical appearance of the first layer, such as "gaps between lines", "ridged" or "blobby".
:::warning
Z-offset systems that rely on nozzle-to-bed contact at print time, such as beacon true zero, are sensitive to filament stuck to the nozzle tip and debris on the bed surface. It is important to keep the nozzle and bed clean to ensure accurate and consistent first layers.
:::
### Causes to consider when diagnosing first layer issues
- Under or over extrusion
  - Extrusion multiplier
  - Extruder tension
  - Filament feed friction (eg, long reverse Bowden tubes)
  - Hotend temperature (too low can lead to underextrusion)
  - Hotend flow capacity limits (eg, printing too fast for the hotend to keep up)
- Bed surface adhesion
  - Bed surface contamination (eg, oils or sugars from fingers)
  - Compatibility of filament and bed surface
  - Separation layers or adhesives
  - Bed temperature
  - First layer speed
- Mechanical issues
  - Nozzle size does not match slicer settings
  - Loose nozzle or any other hotend parts
  - Loose belts
  - Worn pulleys
  - Z leadscrew binding or backlash
