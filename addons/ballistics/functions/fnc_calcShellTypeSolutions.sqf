#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Computes firing solutions for every available charge of a given shell type, from a gun position/elevation/direction to a target position/elevation.
 * Loads the magazine's ballistic table list from its config, then interpolates a solution per charge via calcBtabSolution.
 *
 * Arguments:
 * 0: Shell/magazine classname (CfgMagazines) <STRING>
 * 1: Gun position <ARRAY>
 * 2: Gun elevation (height) <NUMBER>
 * 3: Gun direction (degrees) <NUMBER>
 * 4: Target position <ARRAY>
 * 5: Target elevation (height) <NUMBER>
 *
 * Return Value:
 * Array of firing solutions, one per available charge: [[charge, relativeDirectionMils, deflection, gunElevationMils, timeOfFlight, impactVelocity, impactAngle, maxOrdinate, distance, height], ...] <ARRAY>
 *
 * Example:
 * ["itc_Sh_82mm_HE", [0,0,0], 0, 0, [1000,1000,0], 0] call itc_land_ballistics_fnc_calcShellTypeSolutions
 *
 * Public: No
 */

params ["_shellType", "_gunPos", "_gunElev", "_gunDir", "_targetPos", "_targetEl"];
//_targetPos = [_targetGrid, true] call ace_common_fnc_getMapPosFromGrid;
_distance = [_gunPos # 0, _gunPos # 1] distance [_targetPos # 0, _targetPos # 1];
_elevDiff = _targetEl - _gunElev;

_df = [_gunDir, _gunPos getDir _targetPos] call EFUNC(common,getDeflection);
_relDirMils = (_gunPos getDir _targetPos) / 360 * 6400;
_tableListFile = getText (configFile >> "CfgMagazines" >> _shellType >> "itc_land_btabListFile");
_tableList = []  call compile preProcessFile format[_tableListFile, _shellType];
//_tableList = [vehicle player] call itc_land_fcs_fnc_get_vehicle_tables;
_tableList params ["_charges", "_tables"];

if(isnil{_tables}) exitWith {[]};
_solutions = [];
for "_i" from 0 to (count _charges) - 1 step 1 do {
  _table = _tables # _i;
  _btab = []  call compile preProcessFile _table;
  _solution = [_btab, _distance, _elevDiff] call FUNC(calcBtabSolution);
  if(count _solution > 0) then {
    _solutions pushBack ([_charges # _i,_relDirMils,_df] + _solution);
  };
};
_solutions
