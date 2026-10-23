#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Opens the ammunition handler: in HTML with the setting "Tablet in HTML" (the tablet's web page
 * as a panel, sphammohandler_fnc_webView/webAction), else the classic dialog. The vehicles' ACE
 * action "Open Ammo Handling Interface" calls it.
 *
 * Arguments:
 * 0: The classic dialog also with the setting "Tablet in HTML" <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_sphammohandler_fnc_open
 *
 * Public: No
 */

params [["_classic", false, [false]]];

if (missionNamespace getVariable [QEGVAR(tablet,webTablet), false] && {!_classic}) exitWith {
    ["", "ammo"] call EFUNC(tablet,webOpen);
};
createDialog "ITC_Land_SPHammohandler";
