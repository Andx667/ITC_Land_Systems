#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS engageMission page interactions: "back" returns to the newMission page without
 * saving, "ammoType" refills the fuze list for the selected round, "save" reads the sheaf type,
 * quick/normal, direction/length, shell, round count and fuze selections from the UI controls,
 * stores them as the mission's engagement data, and advances the mission to the
 * solutionMission page. (_listBox/_target/_value are passed by "list" toggle actions but are
 * not currently consumed.)
 *
 * Arguments:
 * 0: Action identifier ("back", "ammoType", "save" or "list") <String>
 * 1: Control IDC of the list/toggle that triggered the action <Number>
 * 2: Selected list index, or -1 <Number>
 * 3: Toggle state or text value ("ON"/"OFF" or control text) <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["save"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action", "_listBox", "_target", "_value"];
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;

if (_action == "back") then {
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "newMission"];
};

if (_action == "ammoType") then {
    [7102, lbData [7100, lbCurSel 7100], lbData [7102, lbCurSel 7102]] call FUNC(bcsFillFuzes);
};

if (_action == "save") then {
    // the quick sheaf list: 0 On, 1 Off
    if !([_mission, lbCurSel 7101, lbCurSel 7401 == 0, UITEXT(7402), UINUMBER(7403), lbCurSel 7100, UINUMBER(7404), lbData [7102, lbCurSel 7102]] call FUNC(bcsSetEngagement)) exitWith {
        [LLSTRING(Bcs_NoAmmoSelected)] call ace_common_fnc_displayTextStructured;
    };
    SAVEMISSION(_mission);
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "solutionMission"];
};
