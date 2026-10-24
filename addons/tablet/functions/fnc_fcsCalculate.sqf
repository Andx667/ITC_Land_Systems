#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The FCI's CALCULATE (SPG and MLRS): the firing solutions of the vehicle's gun on the target
 * grid and elevation for a round, within the elevations the gun can lay, stored on the vehicle
 * (itc_land_tablet_fcs_solutions) with the first one selected. A local solution replaces the
 * fire data the FDC sent. No solution without a grid of 4 to 10 digits or without a round.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Target grid <STRING>
 * 2: Target elevation (m) <NUMBER>
 * 3: Round, magazine class name <STRING>
 *
 * Return Value:
 * Firing solutions <ARRAY>
 *
 * Example:
 * [vehicle player, "01234567", 120, "itc_land_155mm_HE"] call itc_land_tablet_fnc_fcsCalculate
 *
 * Public: No
 */

params ["_vehicle", "_grid", "_elevation", "_round"];

_vehicle setVariable ["itc_land_tablet_fcs_tgtgrid", _grid, true];
_vehicle setVariable [QEGVAR(bcs,fireData), nil, true];

private _solutions = [];
// ACE reads an empty grid as the map origin
if (_grid regexMatch GRID_REGEX && {_round != ""}) then {
    _vehicle setVariable ["itc_land_tablet_fcs_tgtelev", _elevation, true];
    private _targetPos = [_grid, false] call ace_common_fnc_getMapPosFromGrid;
    private _gunPos = getPosASL _vehicle;
    _solutions = [_round, _gunPos, _gunPos # 2, getDir _vehicle, _targetPos, _elevation - ace_common_mapAltitude, _vehicle] call EFUNC(ballistics,calcShellTypeSolutions);
    // the tables can reach steeper or flatter than this gun can lay (guided rockets: after their fixed quadrant)
    _solutions = [_vehicle, _solutions] call EFUNC(common,filterSolutionsByElevation);
};
_vehicle setVariable ["itc_land_tablet_fcs_solutions", _solutions, true];
_vehicle setVariable ["itc_land_tablet_fcs_solutions_index", 0, true];
_solutions
