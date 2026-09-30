#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS solutionMission page interactions: "back" returns to engageMission, "adjust"
 * goes to adjustMission; "solup"/"soldn" step through the available firing solutions;
 * "shot" records the time the mission will land; any action containing "eom" ends the
 * mission (optionally saving its target as a known location first via "eomsave") and
 * returns to locStores. In all cases the page is re-initialized afterward without
 * recalculating the solutions.
 *
 * Arguments:
 * 0: Action identifier ("back", "adjust", "solup", "soldn", "shot", "eom" or "eomsave") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["shot"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;
GVAR(bcs_solutions) params ["_btySolutions", "_gunSolutions"];
if(_action == "back") then {
  (vehicle player) setVariable [QGVAR(page), "engageMission"];
};
if(_action == "adjust") then {
  (vehicle player) setVariable [QGVAR(page), "adjustMission"];
};

if(_action == "solup") then {
  if(_curSolution < _solutionLimit) then {
    _mission set [4, _curSolution + 1];
  };
};
if(_action == "soldn") then {
  _mission set [4, (_curSolution - 1) max 0];
};

if(_action == "shot") then {
  _mission set [6, time + ((_btySolutions # _curSolution) # 4)];
};

if("eom" in _action) then {
  if(_action == "eomsave") then {
    GVAR(bcs_locations) pushBack [_ident, [_tgtPos] call EFUNC(common,posToGrid), _tgtPos , round (_tgtPos # 2), false];
  };
  GVAR(bcs_missions) deleteAt GVAR(bcs_mission_index);
  (vehicle player) setVariable [QGVAR(page), "locStores"];
};
[findDisplay 32562, false] call itc_land_tablet_fnc_pageInit;
