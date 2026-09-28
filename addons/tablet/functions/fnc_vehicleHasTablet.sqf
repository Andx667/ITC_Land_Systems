#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Checks whether the given vehicle has a mounted tablet defined in its
 * config.
 *
 * Arguments:
 * 0: Vehicle to check <Object>
 *
 * Return Value:
 * True if the vehicle has a mounted tablet defined <Boolean>
 *
 * Example:
 * [cursorObject] call itc_land_tablet_fnc_vehicleHasTablet
 *
 * Public: No
 */

params ["_vehicle"];

_tablet = (configOf _vehicle >> "itc_land" >> "mountedTablet")  call BIS_fnc_getCfgData;
(!isNil{_tablet})
