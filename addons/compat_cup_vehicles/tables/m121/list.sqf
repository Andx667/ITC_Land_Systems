#include "..\..\script_component.hpp"

// M121: charges 1 / 2 / 3 = 0.13 / 0.23 / 0.33 of 810 m/s (the ITC M1129's charge magazines; CUP's
// own M121 fires them as its three modes)
[
  ["1", "2", "3"],
  [
    QPATHTOF(tables\m121\m121_ch1_ha.sqf),
    QPATHTOF(tables\m121\m121_ch2_ha.sqf),
    QPATHTOF(tables\m121\m121_ch3_ha.sqf)
  ]
]
