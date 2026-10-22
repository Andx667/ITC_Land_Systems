#include "..\..\script_component.hpp"

// The M119 has the first three vanilla AMOS modes at 810 m/s: the shared b_155 tables
[
  [
    localize "STR_A3_mortar_120mm_AMOS_Single10", localize "STR_A3_mortar_120mm_AMOS_Single10",
    localize "STR_A3_mortar_120mm_AMOS_Single20", localize "STR_A3_mortar_120mm_AMOS_Single20",
    localize "STR_A3_mortar_120mm_AMOS_Single30", localize "STR_A3_mortar_120mm_AMOS_Single30"
  ],
  [
    QPATHTOEF(ballistics,tables\b_155\mortar_155mm_AMOS_0_LA.sqf),
    QPATHTOEF(ballistics,tables\b_155\mortar_155mm_AMOS_0_HA.sqf),
    QPATHTOEF(ballistics,tables\b_155\mortar_155mm_AMOS_1_LA.sqf),
    QPATHTOEF(ballistics,tables\b_155\mortar_155mm_AMOS_1_HA.sqf),
    QPATHTOEF(ballistics,tables\b_155\mortar_155mm_AMOS_2_LA.sqf),
    QPATHTOEF(ballistics,tables\b_155\mortar_155mm_AMOS_2_HA.sqf)
  ]
]
