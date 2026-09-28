/*
 * Author: ToadBall, Yax, VKing
 * Checks whether the vehicle's tablet interfaces config list contains the
 * given interface name.
 *
 * Arguments:
 * 0: Vehicle to check <Object>
 * 1: Interface name to check for <String>
 *
 * Return Value:
 * True if the interface is present <Boolean>
 *
 * Example:
 * [cursorObject, "sadl"] call itc_land_tablet_fnc_vehicleHasInterface
 *
 * Public: No
 */
params ["_vehicle", "_interface"];

_interfaces = (configOf (vehicle player) >> "itc_land" >> "tabletInterfaces")  call BIS_fnc_getCfgData;
if(isNil{_interfaces}) exitWith {false};

_interface in _interfaces
