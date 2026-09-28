/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS settings page interactions: "save" reads the splash time, mission code and
 * mission start number fields and stores them as the current BCS settings.
 *
 * Arguments:
 * 0: Action identifier ("save") <String>
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

if(_action == "save") then {
  bcs_splash_time = UINUMBER(3205);
  bcs_mission_code = UITEXT(3206);
  bcs_mission_start = UINUMBER(3207);
};
