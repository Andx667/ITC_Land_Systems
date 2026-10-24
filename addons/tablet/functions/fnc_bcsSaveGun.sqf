#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * A gun of the BCS battery by hand: number, grid, altitude and direction. A number the battery
 * has updates that gun.
 *
 * Arguments:
 * 0: Gun number <STRING>
 * 1: Grid <STRING>
 * 2: Altitude (m ASL) <NUMBER>
 * 3: Direction (deg) <NUMBER>
 *
 * Return Value:
 * A new gun (else one updated) <BOOL>
 *
 * Example:
 * ["1", "01234567", 120, 90] call itc_land_tablet_fnc_bcsSaveGun
 *
 * Public: No
 */

params ["_num", "_grid", "_elev", "_dir"];

private _pos = ([_grid, false] call ace_common_fnc_getMapPosFromGrid) vectorAdd [0, 0, _elev];
private _gunData = [_num, _grid, _pos, _elev, _dir, GVAR(bcs_bty_name)];
private _gun = GVAR(bcs_bty_guns) findIf {_x # 0 == _num};
if (_gun == -1) exitWith {
    GVAR(bcs_bty_guns) pushBack _gunData;
    true
};
GVAR(bcs_bty_guns) set [_gun, _gunData];
false
