#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS solutionMission page interactions: "back" returns to engageMission, "adjust"
 * goes to adjustMission; "solup"/"soldn" step through the available firing solutions;
 * "shot" records the time the mission will land; "sendadj" sends the firing line of the gun
 * selected in the list (the first gun if none is) and "sendffe" those of all guns
 * (tablet_fnc_bcsSendFireData); any action containing "eom" ends the mission (tablet_fnc_bcsEndMission,
 * "eomsave" records its target as a known location) and returns to locStores. In all cases the page is re-initialized afterward without
 * recalculating the solutions.
 *
 * Arguments:
 * 0: Action identifier ("back", "adjust", "solup", "soldn", "shot", "sendadj", "sendffe", "eom" or "eomsave") <String>
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
if (_action == "back") then {
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "engageMission"];
};
if (_action == "adjust") then {
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "adjustMission"];
};

if (_action == "solup") then {
    if (_curSolution < _solutionLimit) then {
        _mission set [4, _curSolution + 1];
    };
};
if (_action == "soldn") then {
    _mission set [4, (_curSolution - 1) max 0];
};

if (_action == "shot") then {
    [_ident, (_btySolutions # _curSolution) # 4] call FUNC(bcsShot);
};

if (_action in ["sendadj", "sendffe"]) then {
    ([_mission, GVAR(bcs_solutions), _action == "sendffe", lbCurSel 8500] call FUNC(bcsSendFireData)) params ["_report"];
    [_report joinString "<br/>", 1 + count _report] call ace_common_fnc_displayTextStructured;
};

if ("eom" in _action) then {
    [_action == "eomsave"] call FUNC(bcsEndMission);
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "locStores"];
};
[findDisplay 32562, false] call itc_land_tablet_fnc_pageInit;
