#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Sets up the rover UI's video feed for the given aircraft: hides the default
 * optics controls, switches the rover camera to an internal back-facing view,
 * and applies the color-correction/film-grain post-process effects used for the
 * feed's DTV look. If no aircraft is given, kills the feed instead.
 *
 * Arguments:
 * 0: Aircraft to create the video feed for; feed is killed instead if null <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_plane] call itc_land_rover_fnc_createFeed
 *
 * Public: No
 */

params ["_vehicle"];
if (isNull _vehicle) exitWith {
  call FUNC(killFeed);
};
ctrlShow [2205, false];
ctrlShow [1004, false];
ctrlShow [1005, false];
itc_land_rover_camera cameraEffect ["internal", "BACK"];
//"colorCorrections" ppEffectAdjust [0.5, 1.2, 0.3, [1, 1, 1, 0], [1, 1, 1, 0], [0.75, 0.25, 0, 1.0]];
"colorCorrections" ppEffectAdjust [0.9, 0.4, 0, [0.9, 0.4, 0, 0], [1, 1, 1, 0], [1, 1, 1, 0]];
"colorCorrections" ppEffectCommit 0;
"colorCorrections" ppEffectEnable TRUE;
"filmGrain" ppEffectAdjust [0.5, 2, 1, 1, 1];
"filmGrain" ppEffectCommit 0;
"filmGrain" ppEffectEnable TRUE;
