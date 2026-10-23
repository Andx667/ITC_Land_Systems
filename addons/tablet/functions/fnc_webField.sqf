#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * A form field of the HTML tablet (a "fields" block item): a text box, or a select box with
 * options. Its value comes from the form (tablet_fnc_webForm): a string for a text box, the
 * index of the option for a select box. A select box with a change action sends it at once
 * (with the given fields), for choices that change the page.
 *
 * Arguments:
 * 0: Field id <STRING>
 * 1: Label <STRING>
 * 2: Tooltip <STRING> (default: "")
 * 3: Options, for a select box <ARRAY> (default: [], a text box)
 * 4: Change action <STRING> (default: "")
 * 5: Field ids sent with the change action <ARRAY> (default: [the field])
 * 6: Extras <HASHMAP> (default: none): "unit" shown after the box, "hint" in the empty box,
 *    "max" length, "check" [regex, message] checked in the page before a button sends it,
 *    "kind" "check" for a checkbox (value 1 / 0), "button" a button in the field's row
 *
 * Return Value:
 * Field <HASHMAP>
 *
 * Example:
 * ["grid", "Grid", "6 to 10 digits"] call itc_land_tablet_fnc_webField
 *
 * Public: No
 */

params ["_id", "_label", ["_tip", ""], ["_options", []], ["_change", ""], ["_send", []], ["_extras", createHashMap]];

private _field = createHashMapFromArray [["id", _id], ["label", _label], ["tip", _tip]];
if (_options isNotEqualTo []) then {_field set ["options", _options]};
if (_change != "") then {
    _field set ["change", _change];
    _field set ["send", [[_id], _send] select (_send isNotEqualTo [])];
};
{
    if (_x == "check") then {
        _y params ["_regex", "_message"];
        _field set ["check", createHashMapFromArray [["re", _regex], ["msg", _message]]];
    } else {
        _field set [_x, _y];
    };
} forEach _extras;
_field
