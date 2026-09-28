#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Fired event handler for ITC Howitzers firing Mof35-fuzed shells. Reads the
 * firing vehicle's selected fuze mode/value and, unless the fuze is proximity
 * detonation ("pd"), starts a per-frame handler running the matching fuze
 * function (delay, time, or prox) against the fired projectile.
 *
 * Arguments:
 * 0: Vehicle that fired the weapon <OBJECT>
 * 1: Ammo/simulation class of the fired round <STRING>
 * 2: Magazine class fired <STRING>
 * 3: Fired projectile <OBJECT>
 * 4: Gunner occupying the firing turret; function exits if not local <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "", "", "", _ammo, _magazine, _projectile, _gunner] call itc_land_veh_weapons_fnc_firedMof35
 *
 * Public: No
 */

params ["_vehicle", "", "", "", "_ammo", "_magazine", "_projectile", "_gunner"];
if (!local _gunner) exitWith {};
private _fuzeType = _vehicle getVariable ["itc_land_selectedFuzeMode","pd"];
private _fuzeValue = _vehicle getVariable ["itc_land_fuzeValues",0];


if(isNil{_fuzeType}) exitWith {};
if(_fuzeType == "" || _fuzeType == "pd") exitWith {};

private _fuzeMethods = [
  ["delay",FUNC(fuzeDelay)],
  ["time",FUNC(fuzeTime)],
  ["prox",FUNC(fuzeProx)]
];

private _fuzeMethod = _fuzeMethods # (_fuzeMethods findIf {(_x # 0) == _fuzeType}) # 1;
[_fuzeMethod, 0, [_projectile, _magazine, getPosATL _projectile, _fuzeType, _fuzeValue, time,[0,0,0]]] call CBA_fnc_addPerFrameHandler;
