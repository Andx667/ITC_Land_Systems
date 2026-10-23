#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Connects a player's unit to the datalink with an automatic ID (stored as itc_land_datalink_id),
 * once per unit: later calls for the same unit do nothing, and after a respawn the new unit
 * connects again. Used by everything a player sends from (the BCS, the observer optics).
 *
 * Arguments:
 * 0: Unit (default: ACE_player) <OBJECT>
 *
 * Return Value:
 * True if the unit already has its ID <BOOL>
 *
 * Example:
 * [] call itc_land_datalink_fnc_connectPlayer
 *
 * Public: No
 */

params [["_unit", ACE_player]];

if (_unit getVariable [QGVAR(id), ""] != "") exitWith {true};
if (_unit getVariable [QGVAR(connecting), false]) exitWith {false};
_unit setVariable [QGVAR(connecting), true];
[_unit, "", "object_register", true] call FUNC(connect);
false
