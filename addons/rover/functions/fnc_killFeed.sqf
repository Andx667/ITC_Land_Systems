#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Tears down the rover UI's video feed: restores the default optics controls,
 * disables NVG/thermal vision, terminates the rover camera effect, and disables
 * the feed's color-correction/film-grain post-process effects.
 *
 * Arguments:
 * 0: Aircraft the feed was created for <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_plane] call itc_land_rover_fnc_killFeed
 *
 * Public: No
 */

params ["_vehicle"];
ctrlShow [2205, true];
ctrlShow [1004, true];
ctrlShow [1005, true];
camUseNVG false;
false setCamUseTI 1;
itc_land_rover_camera cameraEffect ["terminate", "back"];
"colorCorrections" ppEffectEnable FALSE;
"filmGrain" ppEffectEnable FALSE;
