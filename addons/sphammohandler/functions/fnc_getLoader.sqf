#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Returns the unit in the vehicle's loader seat: the turret named by itc_land >> loaderTurret
 * (its config class name, as turret paths shift with the host mod's turret order).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Loader, objNull without a loader seat or with the seat empty <OBJECT>
 *
 * Example:
 * [_vehicle] call itc_land_sphammohandler_fnc_getLoader
 *
 * Public: No
 */

params ["_vehicle"];

private _loaderTurret = getText (configOf _vehicle >> "itc_land" >> "loaderTurret");
if (_loaderTurret == "") exitWith {objNull};

private _index = fullCrew [_vehicle, "turret"] findIf {configName ([_vehicle, _x # 3] call BIS_fnc_turretConfig) == _loaderTurret};
if (_index == -1) exitWith {objNull};
(fullCrew [_vehicle, "turret"]) # _index # 0
