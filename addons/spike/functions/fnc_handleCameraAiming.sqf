#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Reads the player's aim-input actions (AimLeft/AimRight/AimUp/AimDown) while in
 * the Spike LR seeker camera view, re-centers the mouse cursor, clears any active
 * target lock if the operator manually adjusts aim beyond a small deadzone, and
 * traces a new intersection point to update the current aim/target position.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_spike_fnc_handleCameraAiming
 *
 * Public: No
 */
private _traverse = ((-(inputAction "AimLeft")) + (inputAction "AimRight")) * itc_land_spike_traverseModifier;
private _elevate = ((inputAction "AimUp") + (-(inputAction "AimDown"))) * itc_land_spike_traverseModifier;
setMousePosition [5,5];
if (_traverse == 0 && _elevate == 0) exitWith {};
if (abs _traverse > 0.1 || abs _elevate > 0.1) then {itc_land_spike_lockInformation = [nil, [0,0,0], nil, [0,0,0]];};
// systemChat str [abs _traverse, abs _elevate];
if (!isNil {itc_land_spike_lockInformation # 0}) exitWith {};
private _originPosition = getPosASL itc_land_spike_currentMissile;
private _vect = _originPosition vectorFromTo itc_land_spike_targetPos;
private _polar = _vect call cba_fnc_vect2polar;
private _newDir = [
  (_polar # 1) + _traverse,
  (_polar # 2) + _elevate
];
private _intersect = [_originPosition, _newDir # 0, _newDir # 1, false] call FUNC(intersectAtPolar);
// systemchat str ["intersect", _intersect];
if(!isNil "_intersect") then {
  itc_land_spike_targetPos = _intersect;
};
