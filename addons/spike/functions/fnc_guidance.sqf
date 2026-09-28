#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Missile guidance/attack-profile callback for the in-flight Spike LR missile.
 * Blends the aim point toward the locked target's predicted position (using the
 * target's velocity and remaining time-of-flight) once a lock exists, forces a
 * lofted top-attack aim point offset from the shooter early in flight (before 30%
 * of the flight distance is covered), updates the camera's tracked target
 * position, and scales the film-grain post-process effect based on remaining
 * distance to the target.
 *
 * Arguments:
 * 0: Current seeker target position <Position>
 * 1: Guidance arguments array; element 0 is the original "Fired" event handler params <Array>
 * 2: Attack profile state parameters (unused) <Array>
 *
 * Return Value:
 * Updated target position for the missile to steer toward <Position>
 *
 * Example:
 * [_seekerTargetPos, _args, _attackProfileStateParams] call itc_land_spike_fnc_guidance
 *
 * Public: No
 */
params ["_seekerTargetPos", "_args", "_attackProfileStateParams"];
_args params ["_firedEH"];
_firedEH params ["_shooter","","","","","","_projectile"];
//drop ["\a3\data_f\Cl_basic","","Billboard",1,20,ASLtoAGL itc_land_spike_targetPos,[0,0,0],1,1.275,1.0,0.0,[1],[[1,0,0,1]],[0],0.0,2.0,"","",""];//red fwd
//drop ["\a3\data_f\Cl_basic","","Billboard",1,20,ASLtoAGL itc_land_spike_targetPosCamera,[0,0,0],1,1.275,1.0,0.0,[1],[[0,1,0,1]],[0],0.0,2.0,"","",""];//red fwd
//drop ["\a3\data_f\Cl_basic","","Billboard",1,20,getPos _projectile,[0,0,0],1,1.275,1.0,0.0,[1],[[0,0,1,1]],[0],0.0,2.0,"","",""];//red fwd
private _fullDist = _shooter distance2D itc_land_spike_targetPos;
private _traveledDist = _projectile distance _shooter;
private _progress = _traveledDist / _fullDist;
private _distanceRemaining = (_projectile distance itc_land_spike_targetPos);
private _target = itc_land_spike_targetPos;
private _targetObject = itc_land_spike_lockInformation # 0;
if (!isNil "_targetObject") then {
  private _tofRemaining = _distanceRemaining / (vectorMagnitude velocity _projectile);
  _target = _target vectorAdd ((velocity _targetObject) vectorMultiply _tofRemaining);
};
itc_land_spike_targetPos spawn {sleep 0.05; itc_land_spike_targetPosCamera = _this;};
if (_progress < 0.3) then {
  private _vect = [_fullDist, _shooter getDir itc_land_spike_targetPos, 10] call CBA_fnc_polar2vect;
  _target = (getPosASL _shooter) vectorAdd _vect;
};
//systemChat str _distanceRemaining;
if (_distanceRemaining < 200) then {
  "filmGrain" ppEffectAdjust [0.5, _distanceRemaining / 100, 1, 1, 1];
  "filmGrain" ppEffectCommit 0;
};
_target
