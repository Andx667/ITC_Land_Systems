#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Per-frame handler implementing a proximity (height-of-burst) fuze. Tracks the
 * projectile's position each frame; once it descends below the configured fuze
 * altitude (or is no longer alive), deletes it and spawns the configured
 * submunition at its last known position, then removes the per-frame handler.
 *
 * Arguments:
 * 0: PFH values array: [projectile <OBJECT>, magazine <STRING>, last position <ARRAY>,
 *    fuze type <STRING>, fuze burst altitude <NUMBER>] <ARRAY>
 * 1: CBA per-frame handler ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[_projectile, _magazine, _position, "prox", _fuzeValue, "", ""], _pfhId] call itc_land_veh_weapons_fnc_fuzeProx
 *
 * Public: No
 */

params ["_pfhValues","_pfhId"];
_pfhValues params ["_projectile", "_magazine", "_position", "_fuzeType","_fuzeValue", "",""];

if (alive _projectile) then {
  _position = getPosATL _projectile;
  _pfhValues set [2, _position];
};

_alt = (getPosATL _projectile) select 2;
if((_alt < _fuzeValue && (velocity _projectile) # 2 < 0) || !alive _projectile) exitWith {
  _subMunition = getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_submunition");
  deleteVehicle _projectile; _subMunition createVehicle _position;
  [_pfhId] call CBA_fnc_removePerFrameHandler;
};
