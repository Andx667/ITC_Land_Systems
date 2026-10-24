#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The extras of an HTML tablet text box (tablet_fnc_webField) for a kind of value: the check the
 * page makes before a button sends it, and the unit shown after the box.
 *   grid      4 to 10 digits (with a hint, at most 10)
 *   number    a decimal number, also negative
 *   positive  a decimal number, not negative
 *   mils      mils, also negative and as 6-40
 *   whole     a whole number from 1
 *   count     a whole number from 0
 *   laser     a laser code, 1111 to 1788
 *
 * Arguments:
 * 0: Kind <STRING>
 * 1: Unit <STRING> (default: "")
 *
 * Return Value:
 * Extras <HASHMAP>
 *
 * Example:
 * ["number", "m"] call itc_land_tablet_fnc_webCheck
 *
 * Public: No
 */

params ["_kind", ["_unit", ""]];

private _extras = createHashMapFromArray [["check", switch (_kind) do {
    case "grid": {[GRID_REGEX, LLSTRING(WebCheckGrid)]};
    case "number": {["^-?[0-9]+([.][0-9]+)?$", LLSTRING(WebCheckNumber)]};
    case "positive": {["^[0-9]+([.][0-9]+)?$", LLSTRING(WebCheckNumber)]};
    case "mils": {["^-?[0-9]+([.-][0-9]+)?$", LLSTRING(WebCheckNumber)]};
    case "whole": {["^[1-9][0-9]*$", LLSTRING(WebCheckWhole)]};
    case "count": {["^[0-9]+$", LLSTRING(WebCheckCount)]};
    case "laser": {["^1[1-7][1-8][1-8]$", LLSTRING(WebCheckLaser)]};
}]];
if (_kind == "grid") then {
    _extras set ["hint", LLSTRING(WebHintGrid)];
    _extras set ["max", 10];
};
if (_unit != "") then {_extras set ["unit", _unit]};
_extras
