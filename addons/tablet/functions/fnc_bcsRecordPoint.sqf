#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Records a position as a known point of the BCS location stores (tablet_fnc_bcsSaveLocation):
 * an ended mission's target, a COBRA firing position, an observer's target. The grid is stored as
 * its digits only, as typed grids are, so LOAD can put it in a grid field.
 *
 * Arguments:
 * 0: Point ID <STRING>
 * 1: Position ASL <ARRAY>
 *
 * Return Value:
 * Grid <STRING>
 *
 * Example:
 * ["FM0001", _targetPos] call itc_land_tablet_fnc_bcsRecordPoint
 *
 * Public: No
 */

params ["_id", "_pos"];

if (isNil QGVAR(bcs_locations)) then {GVAR(bcs_locations) = []};
private _grid = ([_pos] call ace_common_fnc_getMapGridFromPos) joinString "";
[_id, _grid, round (_pos # 2), false] call FUNC(bcsSaveLocation);
_grid
