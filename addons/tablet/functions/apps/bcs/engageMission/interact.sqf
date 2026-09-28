/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS engageMission page interactions: "back" returns to the newMission page without
 * saving, "save" reads the sheaf type, quick/normal, direction/length and shell selections
 * from the UI controls, stores them as the mission's engagement data, and advances the
 * mission to the solutionMission page. (_listBox/_target/_value are passed by the "list"
 * toggle actions bound in the engageFiremission2 workspace but are not currently consumed.)
 *
 * Arguments:
 * 0: Action identifier ("back", "save" or "list") <String>
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

if(_action == "back") then {
  (vehicle player) setVariable ["page", "newMission"];
};

if(_action == "save") then {
  _magType = bcs_shellTypes # (bcs_bty_type # 0) # (lbCurSel 7100);
  _engagePage = [lbCurSel 7101, lbCurSel 7401, UINUMBER(7402), UINUMBER(7403), lbCurSel 7100, _magType];
  _mission set [3, _engagePage];
  SAVEMISSION(_mission);
  _mission set [1, "solutionMission"];
  (vehicle player) setVariable ["page", "solutionMission"];
};
