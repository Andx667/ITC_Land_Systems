#include "..\..\..\..\script_component.hpp"

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

if (_action == "save") then {
    // seconds before impact, more than 0 (at 0 SPLASH would never show); nothing is saved until it is valid
    private _splashText = UITEXT(3205);
    if (!(_splashText regexMatch "\s*\d+(\.\d+)?\s*") || {parseNumber _splashText <= 0}) exitWith {
        [LLSTRING(Bcs_InvalidSplashTime)] call ace_common_fnc_displayTextStructured;
    };
    GVAR(bcs_splash_time) = parseNumber _splashText;
    GVAR(bcs_mission_code) = UITEXT(3206);
    GVAR(bcs_mission_start) = UINUMBER(3207);
};
