#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Shows the result of an action in the HTML tablet or ammunition handler, at the top of the page
 * for 8 s (tablet_fnc_webState puts it in the view), instead of an ACE hint beside the tablet.
 *
 * Arguments:
 * 0: Text <STRING>
 * 1: Kind: "" (done), "warn" or "bad" <STRING> (default: "")
 *
 * Return Value:
 * None
 *
 * Example:
 * ["FM0001 FFE sent to guns: 1, 2"] call itc_land_tablet_fnc_webNotice
 *
 * Public: No
 */

params ["_text", ["_kind", ""]];

if (isNil QGVAR(web)) exitWith {};
GVAR(web) set ["notice", [_text, _kind, time + 8]];
