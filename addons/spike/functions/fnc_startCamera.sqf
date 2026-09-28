#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Creates and configures the external seeker camera for an in-flight Spike LR
 * missile: spawns a camera at the missile's position, sets its field of view,
 * orients it toward the current target-camera position, attaches it as the
 * internal back-view camera effect, and opens the Spike seeker UI display.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_spike_fnc_startCamera
 *
 * Public: No
 */

itc_land_spike_camera = "camera" camCreate (getPos itc_land_spike_currentMissile);
itc_land_spike_camera camSetFov 0.08333;

//_camera camSetTarget (ASLtoAGL itc_exp_spike_targetPosCamera);
private _polarToTarget = ((getPosASL itc_land_spike_currentMissile) vectorFromTo itc_land_spike_targetPosCamera) call cba_fnc_vect2polar;
//systemChat str ["polar", _polarToTarget];

itc_land_spike_camera setDir (_polarToTarget # 1);
[itc_land_spike_camera, (_polarToTarget # 2), 0] call bis_fnc_setpitchbank;
itc_land_spike_camera setVectorUp [0,0.5,0];
//itc_land_spike_camera attachTo [itc_land_spike_currentMissile, [0,1,0]];
itc_land_spike_camera cameraEffect ["internal", "BACK"];

findDisplay 46 createDisplay  "ITC_Land_SpikeSeeker";
showCinemaBorder false;
