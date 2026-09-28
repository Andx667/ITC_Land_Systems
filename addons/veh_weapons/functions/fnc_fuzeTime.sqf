#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Per-frame handler implementing a time fuze. Tracks the projectile's position
 * each frame; once the configured fuze time has elapsed (or the projectile is
 * no longer alive), removes the per-frame handler, deletes the projectile, and
 * spawns the configured submunition in its place carrying its last velocity,
 * direction, pitch and bank.
 *
 * Arguments:
 * 0: PFH values array: [projectile <OBJECT>, magazine <STRING>, last position <ARRAY>,
 *    fuze type <STRING>, fuze time <NUMBER>, fired time <NUMBER>] <ARRAY>
 * 1: CBA per-frame handler ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[_projectile, _magazine, _position, "time", _fuzeValue, time, ""], _pfhId] call itc_land_veh_weapons_fnc_fuzeTime
 *
 * Public: No
 */

params ["_pfhValues","_pfhId"];
_pfhValues params ["_projectile", "_magazine", "_position", "_fuzeType","_fuzeTime", "_firedTime",""];

if (alive _projectile) then {
  _position = getPosATL _projectile;
  _pfhValues set [2, _position];
};

_triggered = time > _firedTime + _fuzeTime;

if(_triggered || !alive _projectile) exitWith {
  
  _vProj = velocity _projectile;
  _dProj = getDir _projectile;
  _pbProj = _projectile call BIS_fnc_getPitchBank;
  [_pfhId] call CBA_fnc_removePerFrameHandler;
  deleteVehicle _projectile;
  
  _subMunitionClass = getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_submunition");
  _subMunition = createVehicle [_subMunitionClass, _position, [], 0, "FLY"];
  _subMunition setDir _dProj;
  ([_subMunition] + _pbProj) call BIS_fnc_setPitchBank;  
  _subMunition setVelocity _vProj;
  
};
