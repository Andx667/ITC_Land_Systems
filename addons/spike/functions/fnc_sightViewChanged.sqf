#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles a camera-view change while the Spike LR is equipped. If switching
 * away from gunner view before a missile has been launched (no active camera
 * object exists), treats it as the seeker sight closing; otherwise (re)enables
 * the color-correction and film-grain post-process effects for the seeker view.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_spike_fnc_sightViewChanged
 *
 * Public: No
 */

//systemChat str ["VIEW CHANGED", cameraView];

if (cameraView != "GUNNER" && isNil "itc_land_spike_camera") exitWith {
  [] call FUNC(sightClosed);
};

"colorCorrections" ppEffectAdjust [0.9, 0.4, 0, [0.9, 0.4, 0, 0], [1, 1, 1, 0], [1, 1, 1, 0]];;
"colorCorrections" ppEffectCommit 0;
"colorCorrections" ppEffectEnable true;

"filmGrain" ppEffectAdjust [0.5, 2, 1, 1, 1];
"filmGrain" ppEffectCommit 0;
"filmGrain" ppEffectEnable true;
itc_land_spike_ppEffect = true;
