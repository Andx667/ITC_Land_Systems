#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles the native "Fired" event for the Spike LR launcher. Exits if the firing
 * unit is not local, then initializes the missile-tracking/wobble state (current
 * missile, launch/activation time, ballistic wobble parameters) and computes an
 * initial aim/target point in front of the shooter - either where the player's
 * screen crosshair intersects terrain (if far enough away), or a fallback point
 * 3000m ahead of the shooter - before starting the seeker camera.
 *
 * Arguments:
 * 0: Unit that fired <Object>
 * 1: Weapon fired <String>
 * 2: Muzzle used <String>
 * 3: Fire mode used <String>
 * 4: Ammo used <String>
 * 5: Magazine used <String>
 * 6: Projectile object <Object>
 * 7: Gunner of the vehicle <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_spike_fnc_fired
 *
 * Public: No
 */

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
//player addmagazine _magazine;
if (!local _unit) exitWith {};

itc_land_spike_currentMissile = _projectile;
itc_land_spike_launchTime = cba_missionTime;
itc_land_spike_activationTime = cba_missionTime;

itc_land_spike_wobble = [if (random 1 > 0.5) then [{-1},{1}], 5 + (random 10), (round (random 3)) * 0.25];
private _viewASL = AGLToASL positionCameraToWorld [0,0,0];
private _intersect = [AGLToASL positionCameraToWorld [0,0,0], _viewASL vectorFromTo (AGLToASL positionCameraToWorld [0,0,1])] call FUNC(intersectScreenToWorld);
if (!isNil "_intersect" && {(_intersect distance player) > 500}) then {
    itc_land_spike_targetPos = _intersect;
    itc_land_spike_targetPosCamera = _intersect;
} else {
    private _forward = AGLToASL (player modelToWorld [0,3000,0]);
    itc_land_spike_targetPos = _forward;
    itc_land_spike_targetPosCamera = _forward;
};

[] call FUNC(startCamera);
