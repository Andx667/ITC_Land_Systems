#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Handles the moduleFired event on the machine that owns the vehicle: decrements the APS module's
 * remaining ammo, stores when it fired, and publishes the module state to all machines. Doing this on
 * the vehicle's owner means concurrent interceptions from different shooters do not overwrite each other.
 *
 * Arguments:
 * 0: Vehicle with the APS module <OBJECT>
 * 1: Index of the module in the vehicle's APS module array <NUMBER>
 * 2: Mission time the module fired at <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, 0, cba_missionTime] call itc_land_aps_fnc_onModuleFired
 *
 * Public: No
 */

params ["_vehicle", "_index", "_firedTime"];

if (!local _vehicle) exitWith {};

private _apsModules = _vehicle getVariable ["itc_land_aps_modules", []];
if (_index >= count _apsModules) exitWith {};

private _module = +(_apsModules select _index);
_module set [7, (_module select 7) - 1];
_module set [11, _firedTime];
_apsModules set [_index, _module];

_vehicle setVariable ["itc_land_aps_modules", _apsModules, true];
