#include "..\script_component.hpp"

params ["_cbr"];
_shells = missionNameSpace getVariable "itc_land_cobra_shells";
_toRemove = [];
{
  _dir = deg (_cbr animationPhase "mainTurret");
  _dir = (getDir _cbr - _dir);
  if(_dir > 360) then {_dir = _dir - 360;};
  _angleTo = abs (((_dir) + 360) - ((_cbr getDir _x) + 360));
  _inRange = _x distance _cbr < 10000;
  if(_angleTo < 23 && _inRange && !(terrainIntersectASL [getPosASL _x, (getPosASL _cbr) vectorAdd [0,0,3]])) then {
    _toRemove pushBack _x;
    _impact = [_x] call FUNC(calcImpact);
    [_cbr, _impact] call FUNC(processImpact);
    _origin = [_x] call FUNC(calcOrigin);
    [_cbr, _origin] call FUNC(processOrigin);
    [_cbr, _origin] call FUNC(processEngagement);
  };
  if(!alive _x) then {
    _toRemove pushBack _x;
  }
} forEach _shells;
missionNameSpace setVariable ["itc_land_cobra_shells", _shells - _toRemove];

_activeShells = missionNameSpace getVariable "itc_land_cobra_activeShells";
_toRemoveShells = [];
{
  if(time > _x # 1) then {_toRemoveShells pushBack _x;};
} forEach _activeShells;
missionNameSpace setVariable ["itc_land_cobra_activeShells",_activeShells - _toRemoveShells];
