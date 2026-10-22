#include "..\..\script_component.hpp"

// Vanilla mortar_155mm_AMOS charges (0.19 to 1) at 810 m/s. Guns that only have the first
// three modes (M119, D-30) use the first six tables from their own list.
[
  [
    localize "STR_A3_mortar_120mm_AMOS_Single10", localize "STR_A3_mortar_120mm_AMOS_Single10",
    localize "STR_A3_mortar_120mm_AMOS_Single20", localize "STR_A3_mortar_120mm_AMOS_Single20",
    localize "STR_A3_mortar_120mm_AMOS_Single30", localize "STR_A3_mortar_120mm_AMOS_Single30",
    localize "STR_A3_mortar_120mm_AMOS_Single40", localize "STR_A3_mortar_120mm_AMOS_Single40",
    localize "STR_A3_mortar_120mm_AMOS_Single50", localize "STR_A3_mortar_120mm_AMOS_Single50"
  ],
  [
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_0_LA.sqf),
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_0_HA.sqf),
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_1_LA.sqf),
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_1_HA.sqf),
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_2_LA.sqf),
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_2_HA.sqf),
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_3_LA.sqf),
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_3_HA.sqf),
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_4_LA.sqf),
    QPATHTOF(tables\b_155\mortar_155mm_AMOS_4_HA.sqf)
  ]
]
