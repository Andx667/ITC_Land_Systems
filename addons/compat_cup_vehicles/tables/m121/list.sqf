#include "..\..\script_component.hpp"

// CUP_Vmortar_M121: charges 0.13 / 0.23 / 0.33 at 810 m/s, labelled with its mode names
[
  [localize "STR_A3_mortar_82mm_Single10", localize "STR_A3_mortar_82mm_Single20", localize "STR_A3_mortar_82mm_Single30"],
  [
    QPATHTOF(tables\m121\m121_ch1_ha.sqf),
    QPATHTOF(tables\m121\m121_ch2_ha.sqf),
    QPATHTOF(tables\m121\m121_ch3_ha.sqf)
  ]
]
