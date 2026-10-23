#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Gets the BCS battery type a vehicle can be linked to as a gun of the battery: the battery
 * type (cannon or rocket) whose weapon the vehicle's main turret carries, for vehicles with ITC fire
 * control, a mounted tablet and an ITC gunner sight (they show the fire data the FDC sends). The towed
 * guns (D-30, M119) are just the gun, without tablet or datalink: their crews work by voice, and the
 * BCS takes them as hand-entered guns. Cached per vehicle class.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Battery type class name (itc_land_ballistics >> batteryTypes), or "" if it is no such gun <STRING>
 *
 * Example:
 * [cursorObject] call itc_land_bcs_fnc_getGunBatteryType
 *
 * Public: No
 */

params ["_vehicle"];

if (isNil QGVAR(gunTypeCache)) then {GVAR(gunTypeCache) = createHashMap};

GVAR(gunTypeCache) getOrDefaultCall [typeOf _vehicle, {
    if !(isText (configOf _vehicle >> "itc_land" >> "mountedTablet")) exitWith {""};
    private _turretConfig = [_vehicle, [0]] call BIS_fnc_turretConfig;
    if ((toLower getText (_turretConfig >> "turretInfoType")) select [0, 9] != "itc_land_") exitWith {""};

    private _weapons = getArray (_turretConfig >> "weapons");
    private _types = "true" configClasses (configFile >> "itc_land_ballistics" >> "batteryTypes");
    private _index = _types findIf {getText (_x >> "weaponClass") in _weapons};
    if (_index == -1) then {""} else {configName (_types # _index)}
}, true]
