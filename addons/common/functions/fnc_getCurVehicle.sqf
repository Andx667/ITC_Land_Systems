#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Returns the vehicle the player is currently viewing from: the connected UAV if the camera is on a UAV, otherwise the vehicle ace_player is in.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Current vehicle or UAV <OBJECT>
 *
 * Example:
 * call itc_land_common_fnc_getCurVehicle
 *
 * Public: No
 */

private _return = nil;

if (cameraOn in allUnitsUAV) then {
    _return = getConnectedUav ace_player;
} else {
    _return = vehicle ace_player;
};

_return;
