#include "..\script_component.hpp"

/*
 * Author: Andx
 * Lines of the debug overlay (common_fnc_registerDebug) for an object on the datalink: its ID and group, and those of
 * its crew, who get no label of their own. Only the server knows the registry; every machine sees the public IDs.
 *
 * Arguments:
 * 0: Vehicle or unit <OBJECT>
 *
 * Return Value:
 * Lines, each [text, color] <ARRAY>
 *
 * Example:
 * [_vehicle] call itc_land_datalink_fnc_debugLines
 *
 * Public: No
 */

params [["_object", objNull, [objNull]]];

private _color = [0.4, 0.85, 1, 1];
private _lines = [];

private _id = _object getVariable [QGVAR(id), ""];
if (_id != "") then {
    _lines pushBack [format ["datalink %1 (group %2)", _id, _id select [0, 2]], _color];
};

{
    private _crewId = _x getVariable [QGVAR(id), ""];
    if (_crewId != "") then {
        _lines pushBack [format ["datalink %1: %2", _crewId, name _x], _color];
    };
} forEach ((crew _object) - [_object]);

_lines
