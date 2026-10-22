#include "..\..\script_component.hpp"

// BWA3_mortar_120mm: charges 0.1 / 0.2 / 0.3 at 810 m/s, labelled with BWMod's mode names
[
  [localize "STR_BWA3_Short", localize "STR_BWA3_Medium", localize "STR_BWA3_Long"],
  [
    QPATHTOF(tables\mrs120\mrs120_ch1_ha.sqf),
    QPATHTOF(tables\mrs120\mrs120_ch2_ha.sqf),
    QPATHTOF(tables\mrs120\mrs120_ch3_ha.sqf)
  ]
]
