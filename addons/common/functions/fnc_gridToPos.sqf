#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Converts a map grid string and an elevation above mean sea level into a world position.
 * The Z component is relative to the terrain's map altitude, matching what guidance
 * and fire-control scripts expect.
 *
 * Arguments:
 * 0: Map grid, e.g. "01230456" <STRING>
 * 1: Elevation above mean sea level in meters (default: 0) <NUMBER>
 *
 * Return Value:
 * World position [x, y, z] <ARRAY>
 *
 * Example:
 * ["01230456", 120] call itc_land_common_fnc_gridToPos
 *
 * Public: No
 */

params ["_grid", ["_elevation", 0]];

private _pos = [_grid, true] call CBA_fnc_mapGridToPos;
_pos set [2, _elevation - ace_common_mapAltitude];
_pos
