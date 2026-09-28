#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Called when the Spike LR launcher is selected as the current weapon; installs
 * a per-frame handler that drives the seeker camera and lock/guidance UI each
 * frame while the Spike LR remains the current weapon. The handler removes
 * itself when the player dies, the display closes, or the weapon is switched
 * away; updates state on camera-view changes; processes target-lock handling;
 * tears down the seeker camera once the missile is destroyed; and updates
 * either the pre-launch sight overlay or the in-flight seeker camera view.
 *
 * Arguments:
 * 0: Gunner sight display to run the seeker overlay/camera on <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_spike_fnc_selectSpike
 *
 * Public: No
 */

params ["_display"];

[{
  (_this select 0) params ["_display"];
  if (!alive player || isNull _display || currentWeapon player != "itc_land_spikeLR") exitWith {
    [_this select 1] call CBA_fnc_removePerFrameHandler;
  };

  if (itc_land_spike_cameraMode != cameraView) then {
    [] call FUNC(sightViewChanged);
    itc_land_spike_cameraMode = cameraView;
  };

  call FUNC(handleLock);

  if (!isNil "itc_land_spike_currentMissile" && {isNull itc_land_spike_currentMissile}) exitWith {
    (uiNamespace getVariable "itc_land_spike_ui") closeDisplay 2;
    itc_land_spike_camera cameraEffect ["terminate", "back"];
    camDestroy itc_land_spike_camera;
    itc_land_spike_camera = nil;
    itc_land_spike_currentMissile = nil;
    itc_land_spike_lockInformation = [nil, [0,0,0], nil, [0,0,0]];
  };

  if (isNil "itc_land_spike_camera" && cameraView == "GUNNER") then {
    [_display] call FUNC(updateSightOverlay);
  } else {
    if (!isNil "itc_land_spike_camera") then {
      [] call FUNC(handleCameraAiming);
      [_display] call FUNC(cameraUpdate);
    };
  };

  //systemChat str [time, _display, isNull _display, isNil "_display"];
}, 0, [_display]] call CBA_fnc_addPerFrameHandler;
