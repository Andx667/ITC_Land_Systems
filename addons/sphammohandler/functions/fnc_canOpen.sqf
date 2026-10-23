#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Condition of the ammunition handler's ACE self action: the gunner, or the loader where the
 * vehicle has a loader seat (see getLoader).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Unit <OBJECT>
 *
 * Return Value:
 * Can open the ammunition handler <BOOL>
 *
 * Example:
 * [_vehicle, ACE_player] call itc_land_sphammohandler_fnc_canOpen
 *
 * Public: No
 */

params ["_vehicle", "_unit"];

gunner _vehicle == _unit || {[_vehicle] call FUNC(getLoader) == _unit}
