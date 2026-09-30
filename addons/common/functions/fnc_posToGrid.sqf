#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Converts a world position into a displayable map grid string.
 *
 * Arguments:
 * 0: World position <ARRAY>
 *
 * Return Value:
 * Grid as "EEEE NNNN" <STRING>
 *
 * Example:
 * [getPos player] call itc_land_common_fnc_posToGrid
 *
 * Public: No
 */

params ["_pos"];

([_pos] call ace_common_fnc_getMapGridFromPos) params ["_easting", "_northing"];
format ["%1 %2", _easting, _northing]
