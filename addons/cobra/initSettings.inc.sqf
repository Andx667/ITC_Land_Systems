[
    QGVAR(range), "SLIDER",
    [LSTRING(Range_DisplayName), LSTRING(Range_Description)],
    [ELSTRING(main,Category), LSTRING(DisplayName)],
    [1000, 20000, 10000, 0],
    1
] call CBA_fnc_addSetting;

[
    QGVAR(engagementTime), "SLIDER",
    [LSTRING(EngagementTime_DisplayName), LSTRING(EngagementTime_Description)],
    [ELSTRING(main,Category), LSTRING(DisplayName)],
    [5, 300, 30, 0],
    1
] call CBA_fnc_addSetting;
