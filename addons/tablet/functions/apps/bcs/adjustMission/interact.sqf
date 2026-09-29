#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS adjustMission page interactions: "back" returns to the solutionMission page
 * without saving, "save" recalculates the target grid from the adjustment input fields,
 * stores it on the current mission's target data and returns to solutionMission.
 *
 * Arguments:
 * 0: Action identifier ("back" or "save") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["save"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;
if(_action == "back") then {
  (vehicle player) setVariable [QGVAR(page), "solutionMission"];
};

if(_action == "save") then {
  _tgtPos = [_tgtPos,UINUMBER(9401),UINUMBER(9402),UINUMBER(9403),UINUMBER(9404)] call EFUNC(bcs,adjustGrid);
  _targetPage set [6, _tgtPos];
  _mission set [2, _targetPage];
  SAVEMISSION(_mission);
  (vehicle player) setVariable [QGVAR(page), "solutionMission"];
};
