#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Handles the radarOn event on the machine that owns the vehicle: switches its radar on.
 *
 * Arguments:
 * 0: Vehicle placed by Zeus <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call itc_land_ciws_fnc_radarOn
 *
 * Public: No
 */

params ["_vehicle"];

if (!local _vehicle) exitWith {};

_vehicle setVehicleRadar 1;
