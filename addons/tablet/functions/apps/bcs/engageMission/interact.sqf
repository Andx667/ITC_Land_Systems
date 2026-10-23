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
    private _shellTypes = getArray (configFile >> "itc_land_ballistics" >> "batteryTypes" >> (GVAR(bcs_bty_type) # 1) >> "ammunition");
    private _ammoIndex = lbCurSel 7100;
    private _magType = if (_ammoIndex < 0) then {""} else {_shellTypes param [_ammoIndex, ""]};
    if (_magType == "") exitWith {
        [LLSTRING(Bcs_NoAmmoSelected)] call ace_common_fnc_displayTextStructured;
    };
    _engagePage = [lbCurSel 7101, lbCurSel 7401, UINUMBER(7402), UINUMBER(7403), lbCurSel 7100, _magType, (floor UINUMBER(7404)) max 1, lbData [7102, lbCurSel 7102]];
    _mission set [3, _engagePage];
    SAVEMISSION(_mission);
    _mission set [1, "solutionMission"];
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "solutionMission"];
};
