#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * A button of the HTML tablet (a "buttons" block item or a sidebar button): sends its action,
 * value and the given fields' values to tablet_fnc_webReceive.
 *
 * Arguments:
 * 0: Label <STRING>
 * 1: Action <STRING>
 * 2: Field ids sent with it <ARRAY> (default: [])
 * 3: Tooltip <STRING> (default: "")
 * 4: Value <ANY> (default: nil)
 * 5: Highlighted (sidebar: the page shown) <BOOL> (default: false)
 * 6: Kind: "" a button, "primary" the page's main action, "danger" pressed twice to act <STRING> (default: "")
 * 7: Disabled <BOOL> (default: false)
 *
 * Return Value:
 * Button <HASHMAP>
 *
 * Example:
 * ["SAVE", "bcsSettingsSave", ["splash", "code", "start"]] call itc_land_tablet_fnc_webButton
 *
 * Public: No
 */

params ["_label", "_action", ["_send", []], ["_tip", ""], "_value", ["_active", false], ["_kind", ""], ["_disabled", false]];

private _button = createHashMapFromArray [["label", _label], ["a", _action], ["send", _send], ["tip", _tip], ["active", _active], ["kind", _kind], ["disabled", _disabled]];
if (_kind == "danger") then {_button set ["confirm", LLSTRING(WebConfirm)]};
if (!isNil "_value") then {_button set ["v", _value]};
_button
