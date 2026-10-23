#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The ID for the next BCS known point: the lowest free AB0001, AB0002, ... so new points need no
 * typing and do not overwrite one (an ID that exists updates that point).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Known point ID <STRING>
 *
 * Example:
 * [] call itc_land_tablet_fnc_webNextPointId
 *
 * Public: No
 */

private _taken = (missionNamespace getVariable [QGVAR(bcs_locations), []]) apply {_x # 0};
private _number = 1;
while {format ["AB%1", [_number, 4] call CBA_fnc_formatNumber] in _taken} do {_number = _number + 1};
format ["AB%1", [_number, 4] call CBA_fnc_formatNumber]
