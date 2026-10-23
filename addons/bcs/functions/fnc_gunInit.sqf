#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Sets up an ITC gun for fire direction over the datalink; other vehicles are skipped. On the
 * server it connects the gun, so it gets an ID (public as itc_land_datalink_id) and handlers for
 * the FDC's "fdc"/"fireData" and "fdc"/"endMission" transmissions. On every machine it adds a
 * Fired handler that reports the first shot of received fire data to the FDC (onGunFired; only
 * the machine where the gun is local acts, a remote vehicle's Fired only triggers near the camera).
 * Runs for every vehicle on every machine (CBA InitPost).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call itc_land_bcs_fnc_gunInit
 *
 * Public: No
 */

params ["_vehicle"];

if ([_vehicle] call FUNC(getGunBatteryType) == "") exitWith {};

_vehicle addEventHandler ["Fired", {[_this select 0] call FUNC(onGunFired)}];

if (!isServer) exitWith {};

// the handlers live on the machine that connects, so the server receives the gun's fire data
[_vehicle, "", "object_register", true] call EFUNC(datalink,connect);
[_vehicle, "fdc", "fireData", FUNC(onFireData)] call EFUNC(datalink,registerEvent);
[_vehicle, "fdc", "endMission", FUNC(onEndMission)] call EFUNC(datalink,registerEvent);
