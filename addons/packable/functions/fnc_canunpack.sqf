#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Checks whether a unit is eligible to unpack a packable item: the unit must
 * be a man (not inside a vehicle) and must be carrying at least one item
 * whose CfgWeapons config inherits from itc_land_packableItem.
 *
 * Arguments:
 * 0: Unit to check <OBJECT>
 *
 * Return Value:
 * True if the unit is a man carrying a packable item <BOOLEAN>
 *
 * Example:
 * [_unit] call itc_land_packable_fnc_canunpack
 *
 * Public: No
 */

params ["_unit"];
if (!((vehicle _unit) isKindOf 'Man')) exitWith { false };

private _items = [_unit] call CBA_fnc_uniqueUnitItems;
private _check = _items findIf { "itc_land_packableItem" in ([(configFile >> "CfgWeapons" >> _x), true] call BIS_fnc_returnParents) };
if (_check < 0) exitWith { false };

true;
