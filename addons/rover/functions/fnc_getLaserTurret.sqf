#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Finds the first turret (including the driver position) on the given vehicle
 * that carries a laser-designator weapon.
 *
 * Arguments:
 * 0: Vehicle to search <OBJECT>
 *
 * Return Value:
 * Turret path of the first turret carrying a laser designator <ARRAY> (nil if none found)
 *
 * Example:
 * [_plane] call itc_land_rover_fnc_getLaserTurret
 *
 * Public: No
 */

params ["_vehicle"];
private _turrets = allTurrets _vehicle;
_turrets pushBack [-1]; //driver
scopeName "main";
private ["_allWeapons", "_turret", "_lasers"];
{
  _turret = _x;
  _allWeapons = _vehicle weaponsTurret _x;
  _lasers = {_x isKindOf ["Laserdesignator_mounted", configFile >> "cfgWeapons"]} count _allWeapons;
  if (_lasers > 0) then {_turret breakOut "main"};
} forEach _turrets;
