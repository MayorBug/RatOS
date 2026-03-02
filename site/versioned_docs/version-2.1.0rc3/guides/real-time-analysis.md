# Realtime Analysis Tool

:::warning 2.1 documentation is incomplete.
This is preliminary documentation for the upcoming v2.1.0 release. The work is still ongoing and the documentation is not yet complete.
:::

The Realtime Analysis Tool is a tool that allows you to analyze the resonance of your printer in realtime. You can select the supported accelerometers in the dropdown menu in the top left corner of the analysis tool.

## Toolhead Oscillator

The Toolhead Oscillator can be started by clicking `Stream` -> `Start Stream` in the toolbar, and then selecting an axis and oscillation frequency in `Tools` -> `Toolhead Oscillator`. You can use this to find resonance and vibration problems of your printer by provoking problematic resonance frequencies, then physically touch suspected parts of the printer to see if the amplitude of the problematic peak in the live PSD graph changes.

![Realtime Analysis Tool](/img/real-time-tool.png)

## Custom Power Spectral Density Graph Macros

You can use the Real-time Analysis Tool to create your own custom analysis macros. This will provide some extra features such as peak matching, mechanical health analysis, shaper fitting and more. To create a new macro select `Macros` -> `New Macro` in the toolbar.

![Realtime Analysis Tool - Belt Tensioning Macro](/img/real-time-tool-belt-tension.png)

The run it from the `Macros` tab in the real time tool.

If you omit the second recording sequence, you'll instead get input shaper analysis of the recorded axis.

All previous recordings can be viewed in historical context in the `Macro Overview`.
