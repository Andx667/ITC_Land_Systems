#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * A known point of the BCS location stores: ID, grid, altitude and friendly. An ID the stores
 * have updates that point.
 *
 * Arguments:
 * 0: Point ID <STRING>
 * 1: Grid <STRING>
 * 2: Altitude (m ASL) <NUMBER>
 * 3: Friendly <BOOL>
 *
 * Return Value:
 * A new point (else one updated) <BOOL>
 *
 * Example:
 * ["AB0001", "01234567", 120, false] call itc_land_tablet_fnc_bcsSaveLocation
 *
 * Public: No
 */

params ["_id", "_grid", "_elev", "_friendly"];

private _pos = ([_grid, false] call ace_common_fnc_getMapPosFromGrid) vectorAdd [0, 0, _elev];
// friendly as the classic list's "no" / "yes"
private _locData = [_id, _grid, _pos, _elev, ["no", "yes"] select _friendly];
private _location = GVAR(bcs_locations) findIf {_x # 0 == _id};
if (_location == -1) exitWith {
    GVAR(bcs_locations) pushBack _locData;
    true
};
GVAR(bcs_locations) set [_location, _locData];
false
