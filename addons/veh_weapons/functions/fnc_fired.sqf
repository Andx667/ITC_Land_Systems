#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Main "Fired" event handler for ITC weapons. Looks up the fired magazine's
 * configured fuze, dispersion, and guidance init event functions from
 * ITC_Land_CfgFuzes/CfgMagazines and, if defined, calls each with the original
 * Fired event arguments.
 *
 * Arguments:
 * 0: Unit/vehicle that fired the weapon <OBJECT>
 * 1: Ammo/simulation class of the fired round <STRING>
 * 2: Magazine class fired <STRING>
 * 3: Fired projectile <OBJECT>
 * 4: Gunner occupying the firing turret; function exits if not local <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "", "", "", _ammo, _magazine, _projectile, _gunner] call itc_land_veh_weapons_fnc_fired
 *
 * Public: No
 */

params ["_unit", "", "", "", "_ammo", "_magazine", "_projectile", "_gunner"];
if (!local _gunner) exitWith {};

private _fuze = getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_fuze");
private _event = configFile >> "ITC_Land_CfgFuzes" >> _fuze >> "firedEvent";

if (isText _event) then {
  _this call (missionNamespace getVariable [getText _event, {}]);
};

private _dispersionEvent = configFile >> "CfgMagazines" >> _magazine >> "dispersionEvent";
if (isText _dispersionEvent) then {
  _this call (missionNamespace getVariable [getText _dispersionEvent, {}]);
};

private _guidanceConfig = (configFile >> "CfgMagazines" >> _magazine >> "itc_land_guidance") call BIS_fnc_getCfgData;

if (!isNil{_guidanceConfig # 1}) then {
    //player sideChat format["INIT GUIDANCE %1",_guidanceConfig # 0];
  _this call (missionNamespace getVariable [_guidanceConfig # 1, {}]);
};
