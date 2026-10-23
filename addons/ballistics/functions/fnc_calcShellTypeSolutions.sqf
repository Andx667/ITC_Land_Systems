#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Computes firing solutions for every available charge of a given shell type, from a gun position/elevation/direction to a target position/elevation.
 * Loads the magazine's ballistic table list from its config, then computes a solution per charge via calcBtabSolution.
 * Compiled table lists and tables are cached in itc_land_ballistics_tableCache after first use.
 * A round with itc_land_heightModifier is aimed that many metres above the target (illumination at its burst
 * point), and every solution gets the round's time fuze setting (calcFuzeSetting, -1 without a time fuze).
 * With the gun's vehicle the trajectory starts at the muzzle as it will be for each charge's quadrant (the barrel's
 * breech plus its length, common_fnc_getBarrel), refined twice; without it, at the given gun position and elevation.
 * A round with itc_land_fixedQuadrant (the guided rockets) gets that quadrant.
 *
 * Arguments:
 * 0: Shell/magazine classname (CfgMagazines) <STRING>
 * 1: Gun position <ARRAY>
 * 2: Gun elevation (height) <NUMBER>
 * 3: Gun direction (degrees) <NUMBER>
 * 4: Target position <ARRAY>
 * 5: Target elevation (height) <NUMBER>
 * 6: The gun's vehicle, for the muzzle position (default: objNull, the gun position) <OBJECT>
 *
 * Return Value:
 * Array of firing solutions, one per available charge: [[charge, relativeDirectionMils, deflection, gunElevationMils, timeOfFlight, impactVelocity, impactAngle, maxOrdinate, distance, height, fuzeSetting], ...] <ARRAY>
 *
 * Example:
 * ["itc_Sh_82mm_HE", [0,0,0], 0, 0, [1000,1000,0], 0] call itc_land_ballistics_fnc_calcShellTypeSolutions
 *
 * Public: No
 */

params ["_shellType", "_gunPos", "_gunElev", "_gunDir", "_targetPos", "_targetEl", ["_vehicle", objNull]];
//_targetPos = [_targetGrid, true] call ace_common_fnc_getMapPosFromGrid;
private _distance = [_gunPos # 0, _gunPos # 1] distance [_targetPos # 0, _targetPos # 1];
private _aimHeight = _targetEl + getNumber (configFile >> "CfgMagazines" >> _shellType >> "itc_land_heightModifier");
private _elevDiff = _aimHeight - _gunElev;
private _barrel = if (isNull _vehicle) then {[]} else {[_vehicle] call EFUNC(common,getBarrel)};
private _fixedQuadrant = getNumber (configFile >> "CfgMagazines" >> _shellType >> "itc_land_fixedQuadrant");

private _df = [_gunDir, _gunPos getDir _targetPos] call EFUNC(common,getDeflection);
private _relDirMils = (_gunPos getDir _targetPos) / 360 * 6400;
private _tableListFile = getText (configFile >> "CfgMagazines" >> _shellType >> "itc_land_btabListFile");
if (_tableListFile == "") exitWith {[]};
private _tableListPath = format [_tableListFile, _shellType];
// Table files are large; compile each once and reuse it (the arrays are only read)
private _tableList = GVAR(tableCache) getOrDefaultCall [_tableListPath, {[] call compile preprocessFile _tableListPath}, true];
//_tableList = [vehicle player] call itc_land_fcs_fnc_get_vehicle_tables;
_tableList params ["_charges", "_tables"];

if (isNil{_tables}) exitWith {[]};
private _solutions = [];
for "_i" from 0 to (count _charges) - 1 step 1 do {
    private _table = _tables # _i;
    private _btab = GVAR(tableCache) getOrDefaultCall [_table, {[] call compile preprocessFile _table}, true];
    private _solution = [_btab, _distance, _elevDiff] call FUNC(calcBtabSolution);
    if (_barrel isNotEqualTo [] && {_solution isNotEqualTo []}) then {
        // from the muzzle at this solution's quadrant; the quadrant hardly moves, two passes settle it
        _barrel params ["_breech", "_length"];
        private _azimuth = _gunPos getDir _targetPos;
        for "_pass" from 1 to 2 do {
            private _elevation = (_solution # 0) * 360 / 6400;
            private _muzzle = _breech vectorAdd [_length * cos _elevation * sin _azimuth, _length * cos _elevation * cos _azimuth, _length * sin _elevation];
            private _refined = [_btab, [_muzzle # 0, _muzzle # 1] distance2D [_targetPos # 0, _targetPos # 1], _aimHeight - (_muzzle # 2)] call FUNC(calcBtabSolution);
            if (_refined isNotEqualTo []) then {_solution = _refined};
        };
    };
    if (count _solution > 0) then {
        // guided rockets are launched at a fixed quadrant and steer to the target
        if (_fixedQuadrant > 0) then {_solution set [0, _fixedQuadrant]};
        _solution = [_charges # _i,_relDirMils,_df] + _solution;
        _solution pushBack ([_shellType, _solution] call FUNC(calcFuzeSetting));
        _solutions pushBack _solution;
    };
};
_solutions
