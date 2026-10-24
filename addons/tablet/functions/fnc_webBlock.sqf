#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * A workspace block of the HTML tablet (tablet.html draws it by its type): "section", "fields",
 * "bar", "buttons", "list", "kv", "stepper", "note", "row", "col", "tiles", "map", "image".
 *
 * Arguments:
 * 0: Type <STRING>
 * 1: Its keys and values <ARRAY of [key, value]> (default: [])
 *
 * Return Value:
 * Block <HASHMAP>
 *
 * Example:
 * ["section", [["text", "TARGET"]]] call itc_land_tablet_fnc_webBlock
 *
 * Public: No
 */

params ["_type", ["_pairs", []]];

private _block = createHashMapFromArray _pairs;
_block set ["t", _type];
_block
