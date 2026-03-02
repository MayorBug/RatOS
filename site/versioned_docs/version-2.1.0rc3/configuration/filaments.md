# Filament Macros

- [LOAD_FILAMENT](#load_filament)
- [UNLOAD_FILAMENT](#unload_filament)
- [M600](#m600)

## LOAD_FILAMENT

- **Parameters** `[TOOLHEAD|TEMP]`

    `TOOLHEAD` = Required only for IDEX printers. 0 = Left toolhead, 1 = Right toolhead. Default: -1

    `TEMP` = The hotend temperature for the loading process. Default value is 220°C.

## UNLOAD_FILAMENT

- **Parameters** `[TOOLHEAD|TEMP]`

    `TOOLHEAD` = Required only for IDEX printers. 0 = Left toolhead, 1 = Right toolhead. Default: -1

    `TEMP` = The hotend temperature for the unloading process. Default value is 220°C.

## M600

- **Parameters**

    Pauses the print and unloads the filament from the hotend. Use this macro for manual filament changes.
