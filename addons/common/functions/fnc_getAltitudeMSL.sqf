#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Returns an object's altitude above mean sea level, rounded to whole meters.
 *
 * Arguments:
 * 0: Object <OBJECT>
 *
 * Return Value:
 * Altitude in meters <NUMBER>
 *
 * Example:
 * [_uav] call itc_land_common_fnc_getAltitudeMSL
 *
 * Public: No
 */

params ["_object"];

round ((getPosASL _object) select 2) + ace_common_mapAltitude
