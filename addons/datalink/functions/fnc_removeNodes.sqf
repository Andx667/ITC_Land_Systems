#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Removes every node registry entry whose object (index 0) or connecting machine ID (index 1) matches the given value. Server-side only.
 *
 * Arguments:
 * 0: Registry entry field to match: 0 for the object, 1 for the machine ID <Number>
 * 1: Value to match <Object or Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [0, _object] call itc_land_datalink_fnc_removeNodes
 *
 * Public: No
 */

params ["_index", "_match"];

private _toRemoveIDs = [];
[itc_land_datalink_nodes, {
  if ((_value # _index) isEqualTo _match) then {
    _toRemoveIDs pushBack _key;
  };
}] call CBA_fnc_hashEachPair;
{
  [itc_land_datalink_nodes, _x] call CBA_fnc_hashRem;
} forEach _toRemoveIDs;
