#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Calculates a full battery fire-mission solution: derives each gun's
 * individual aim point from the sheaf pattern (parallel, converged, linear,
 * open or special/custom) selected in the engagement settings, applies any
 * magazine height/time-of-flight config modifiers, and computes both a
 * battery-centre ballistic solution and a per-gun ballistic solution via
 * EFUNC(ballistics,calcShellTypeSolutions).
 *
 * Arguments:
 * 0: Guns in the battery <ARRAY> of [gun number <NUMBER>, position string <STRING>, position <ARRAY> (Position ASL), elevation <NUMBER>, direction <NUMBER>]
 * 1: Shell type <STRING> (CfgAmmo/CfgMagazines classname)
 * 2: Fire-mission target position <ARRAY> (Position ASL)
 * 3: Engagement settings <ARRAY> of [sheaf type <NUMBER> (0: Parallel, 1: Converged, 2: Linear, 3: Open, 4: Special), sheaf quick flag <NUMBER>/<BOOLEAN>, sheaf direction <NUMBER>, sheaf size <NUMBER>, shell type index <NUMBER>, magazine <STRING>]
 *
 * Return Value:
 * Battery and per-gun solutions <ARRAY> in the format [battery solution <ARRAY>, gun solutions <ARRAY> of [gun number <NUMBER>, gun solution <ARRAY>]]
 *
 * Example:
 * [_guns, _shellType, _targetPos, _engagement] call itc_land_bcs_fnc_calcSolutions
 *
 * Public: No
 */

params ["_guns", "_shellType", "_targetPos", "_engagement"];
_engagement params ["_sheafType", "_sheafQuick", "_sheafDir", "_sheafSize","_shellTypeIndex","_magazine"];

_magazineHeightModifier = configFile >> "CfgMagazines" >> _magazine >> "itc_land_heightModifier";
_magazineHeightModifier = if(isNumber _magazineHeightModifier) then [{getNumber _magazineHeightModifier}, {0}];
_targetPos = _targetPos vectorAdd [0,0,_magazineHeightModifier];
_magazineTimeModifier = configFile >> "CfgMagazines" >> _magazine >> "itc_land_timeModifier";
_magazineTimeModifier = if(isNumber _magazineTimeModifier) then [{getNumber _magazineTimeModifier}, {0}];

_batteryPos = [_guns] call FUNC(getBatteryPosition);
_batterySolution = [_shellType, _batteryPos, _batteryPos # 2, 0, _targetPos, _targetPos # 2] call EFUNC(ballistics,calcShellTypeSolutions);

_gunTargets = [];
_gunTargetLine = ((_batteryPos getDir _targetPos)/360*6400);
switch(_sheafType) do { //0: Parralel, 1: Converged, 2: Linear, 3: Open, 4: Special
  case 0: { //Parralel
    {
      _x params ["_num", "_posStr", "_pos", "_elev", "_dir"];
      _gunTargets pushBack (_targetPos vectorAdd (_pos vectorDiff _batteryPos));
    }forEach _guns;
  };
  case 1: { //converged
    {
      _gunTargets pushBack _targetPos;
    }forEach _guns;
  };
  case 2: { //linear
    {_gunTargets pushBack ([_targetPos, _gunTargetLine, 0, (40 * (_forEachIndex - 1)), 0] call FUNC(adjustGrid));}forEach _guns;
  };
  case 3: { //Open
    {_gunTargets pushBack ([_targetPos, _gunTargetLine, 0, (60 * (_forEachIndex - 1)), 0] call FUNC(adjustGrid));}forEach _guns;
  };
  case 4: { //Open
    _sheafDir = if(_sheafQuick == 1) then [{_sheafDir},{_gunTargetLine}];
    _widthPerGun = _sheafSize / (count _guns);
    _halfSheaf = _sheafSize / 2;
    {
      _offSet = ((_forEachIndex + 1) * _widthPerGun - (_widthPerGun / 2) - _halfSheaf);
      _gunTargets pushBack ([_targetPos, _sheafDir, 0, _offSet, 0] call FUNC(adjustGrid));
    }forEach _guns;
  };
};

_gunSolutions = [];
{
  _x params ["_num", "_posStr", "_pos", "_elev", "_dir"];
  _gunSolution = [_shellType, _pos, _pos # 2, _dir, (_gunTargets # _forEachIndex), (_gunTargets # _forEachIndex) # 2] call EFUNC(ballistics,calcShellTypeSolutions);
  _gunSolution apply {_x set [4, (_x # 4) + _magazineTimeModifier]};
  _gunSolutions pushBack [_num, _gunSolution];
}forEach _guns;

[_batterySolution, _gunSolutions]
