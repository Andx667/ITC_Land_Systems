#include "..\script_component.hpp"

/*
 * Author: Andx
 * Lines of the debug overlay (common_fnc_registerDebug) for an ITC gun or the FDC: a gun's battery type, whether this
 * machine's BCS links it, the fire data it received and, where the gun is local, whether its first shot was reported;
 * the FDC's battery, linked guns and missions. The BCS battery only exists on the FDC's machine.
 *
 * Arguments:
 * 0: Gun or FDC unit <OBJECT>
 *
 * Return Value:
 * Lines, each [text, color] <ARRAY>
 *
 * Example:
 * [_gun] call itc_land_bcs_fnc_debugLines
 *
 * Public: No
 */

params [["_object", objNull, [objNull]]];

private _guns = missionNamespace getVariable [QEGVAR(tablet,bcs_bty_guns), []];
private _batteryName = missionNamespace getVariable [QEGVAR(tablet,bcs_bty_name), ""];

if (_object isEqualTo ACE_player) exitWith {
    private _missions = missionNamespace getVariable [QEGVAR(tablet,bcs_missions), []];
    [[format ["FDC %1 | %2 guns linked | %3 missions", _batteryName, count _guns, count _missions], [1, 0.85, 0.3, 1]]]
};

private _lines = [];

private _type = [_object] call FUNC(getGunBatteryType);
private _linked = _guns findIf {(_x param [6, objNull]) isEqualTo _object};
_lines pushBack (if (_linked == -1) then {
    [format ["BCS %1 gun | not linked by this machine's BCS", _type], [0.85, 0.85, 0.85, 1]]
} else {
    [format ["BCS %1 gun | gun %2 of %3 (linked here)", _type, (_guns # _linked) # 0, _batteryName], [1, 0.85, 0.3, 1]]
});

private _fireData = _object getVariable [QGVAR(fireData), []];
if (_fireData isEqualTo []) exitWith {
    _lines pushBack ["no fire data", [0.85, 0.85, 0.85, 1]];
    _lines
};

_fireData params ["_mission", "_phase", "_magazine", "_origin", "_count", "_fuzeMode", "", "_received"];
_lines pushBack [
    format [
        "fire data %1 %2 from %3 | %4x %5 | fuze %6 | %7 s ago",
        _mission, _phase, _origin, _count, getText (configFile >> "CfgMagazines" >> _magazine >> "displayName"), _fuzeMode, round (CBA_missionTime - _received)
    ],
    [1, 0.6, 0.2, 1]
];

// shotReported is kept where the gun is local, it is not public
if (local _object) then {
    private _reported = (_object getVariable [QGVAR(shotReported), -2]) isEqualTo _received;
    _lines pushBack [
        ["first shot not fired yet", "SHOT reported to the FDC"] select _reported,
        [[1, 0.6, 0.2, 1], [0.3, 1, 0.3, 1]] select _reported
    ];
};

_lines
