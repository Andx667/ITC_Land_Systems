[
    QGVAR(russianMils), "CHECKBOX",
    [LSTRING(RussianMils_DisplayName), LSTRING(RussianMils_Description)],
    [ELSTRING(main,Category), LSTRING(FireControl)],
    true,
    1
] call CBA_fnc_addSetting;

// per player and off by default; a server that does not want it can force it off
[
    QGVAR(debug), "CHECKBOX",
    [LSTRING(Debug_DisplayName), LSTRING(Debug_Description)],
    [ELSTRING(main,Category), LSTRING(Debug)],
    false,
    0,
    LINKFUNC(debugToggle)
] call CBA_fnc_addSetting;
