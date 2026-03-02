# IDEX Macros

- [IDEX_SINGLE](#idex_single)
- [IDEX_COPY](#idex_copy)
- [IDEX_MIRROR](#idex_mirror)
- [IDEX_PARK](#idex_park)
- [JOIN_SPOOLS](#join_spools)
- [REMAP_TOOLHEADS](#remap_toolheads)

## IDEX Printing Modes

Independent Dual Extrusion (IDEX) 3D printers offer versatile printing modes for enhanced productivity and flexibility.

### IDEX_SINGLE

Single toolhead mode for single color, multicolor, and multimaterial prints. This is the default printing mode.

### IDEX_COPY

Prints two identical models simultaneously. Run this macro before starting a print to enable COPY mode. The printer returns to single toolhead mode after print completion.

### IDEX_MIRROR

Prints both your model and its mirror image simultaneously. Run this macro before starting a print to enable MIRROR mode. The printer returns to single toolhead mode after print completion.

### IDEX_PARK

Parks the active toolhead in its designated position. Only available in single toolhead mode when not printing.

## IDEX Extras

### JOIN_SPOOLS

- **Parameters** `[SPOOLS]`

    Automatically switches to another filament spool upon detecting runout. Requires RatOS runout sensor configuration per the [official documentation](filament_sensors.md).

    `SPOOLS` = Specify spool combination (e.g., `0,1` or `1,0`). Both formats achieve the same result.

    To disable this feature, run the `JOIN_SPOOLS` macro without parameters.

### REMAP_TOOLHEADS

- **Parameters** `[TOOLHEADS]`

    Swaps toolhead assignments for:

    - Reprinting multicolor files with swapped toolheads
    - Reprinting single toolhead prints with the other toolhead

    `TOOLHEADS` = Specify toolhead order (e.g., `0,1` or `1,0`). Both formats achieve the same result.

    To disable this feature, run the `REMAP_TOOLHEADS` macro without parameters.
