#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Tears down the missile camera view: ends and destroys the seeker camera, closes the
 * seeker display and switches the sight post-process effects off. Safe to call when
 * no camera is active.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_spike_fnc_stopCamera
 *
 * Public: No
 */

if (!isNil "itc_land_spike_camera") then {
  itc_land_spike_camera cameraEffect ["terminate", "back"];
  camDestroy itc_land_spike_camera;
  itc_land_spike_camera = nil;
};

private _ui = uiNamespace getVariable ["itc_land_spike_ui", displayNull];
if (!isNull _ui) then {
  _ui closeDisplay 2;
};

call FUNC(sightClosed);
