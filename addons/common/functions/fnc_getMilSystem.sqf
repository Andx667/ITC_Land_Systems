#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Gets the mil system angles are shown in for a gun or a BCS battery type: 6000 (Russian, shown
 * as "15-00") for the battery types with milSystem = 6000 in config (the Russian guns) while the
 * itc_land_common_russianMils setting is on, else 6400 (NATO). A vehicle has the system of the
 * battery type whose weapon its main turret carries (cached per vehicle class). Everything is
 * computed in 6400 mils; only the display and the BCS inputs follow this.
 *
 * Arguments:
 * 0: Vehicle <OBJECT> or battery type class name <STRING>
 *
 * Return Value:
 * 6000 or 6400 <NUMBER>
 *
 * Example:
 * [vehicle player] call itc_land_common_fnc_getMilSystem
 *
 * Public: No
 */

params ["_gun"];

if !(missionNamespace getVariable [QGVAR(russianMils), true]) exitWith {6400};

private _batteryTypes = configFile >> "itc_land_ballistics" >> "batteryTypes";
if (_gun isEqualType "") exitWith {
    [6400, 6000] select (getNumber (_batteryTypes >> _gun >> "milSystem") == 6000)
};

if (isNil QGVAR(milSystemCache)) then {GVAR(milSystemCache) = createHashMap};
GVAR(milSystemCache) getOrDefaultCall [typeOf _gun, {
    private _weapons = getArray (([_gun, [0]] call BIS_fnc_turretConfig) >> "weapons");
    private _types = "getNumber (_x >> 'milSystem') == 6000" configClasses _batteryTypes;
    [6400, 6000] select (_types findIf {getText (_x >> "weaponClass") in _weapons} != -1)
}, true]
