#include "..\..\..\..\script_component.hpp"

params ["_action"];
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;
if(_action == "back") then {
  (vehicle player) setVariable ["page", "solutionMission"];
};

if(_action == "save") then {
  _tgtPos = [_tgtPos,UINUMBER(9401),UINUMBER(9402),UINUMBER(9403),UINUMBER(9404)] call EFUNC(bcs,adjustGrid);
  _targetPage set [6, _tgtPos];
  _mission set [2, _targetPage];
  SAVEMISSION(_mission);
  (vehicle player) setVariable ["page", "solutionMission"];
};
