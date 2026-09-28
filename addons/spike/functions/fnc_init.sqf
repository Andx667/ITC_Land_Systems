#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the global state variables used by the Spike LR camera, lock and
 * guidance system (camera mode, camera handle, current missile reference, lock
 * information tuple, camera traverse sensitivity, launch time, ballistic wobble
 * parameters, debug flag, and post-process effect flag).
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_spike_fnc_init
 *
 * Public: No
 */

itc_land_spike_cameraMode = "";
itc_land_spike_camera = nil;
itc_land_spike_currentMissile = nil;
itc_land_spike_lockInformation = [nil, [0,0,0], nil, [0,0,0]];
itc_land_spike_traverseModifier = 0.05;
itc_land_spike_launchTime = 0;
itc_land_spike_wobble = [-1, 15, 0.25];
itc_land_spike_debug = false;
itc_land_spike_ppEffect = false;
