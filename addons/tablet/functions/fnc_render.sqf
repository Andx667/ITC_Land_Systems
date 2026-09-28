#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Updates the tablet screen's fade level (control 15117) to match the
 * current ambient brightness, simulating screen backlight visibility.
 *
 * Arguments:
 * 0: Tablet display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562] call itc_land_tablet_fnc_render
 *
 * Public: No
 */

params ["_display"];

private _illumination = ([] call ace_common_fnc_ambientBrightness);
(_display displayCtrl (15117)) ctrlSetFade _illumination;
(_display displayCtrl (15117)) ctrlCommit 0;
