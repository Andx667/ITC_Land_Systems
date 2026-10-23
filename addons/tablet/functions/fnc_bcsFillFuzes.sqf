#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Fills a list or combo box with the fuze modes of a round (its itc_land_fuze in
 * ITC_Land_CfgFuzes), each entry's data being the mode ("pd", "prox", "time", "delay").
 * Empty for rounds without an ITC fuze.
 *
 * Arguments:
 * 0: IDC of the list or combo box <NUMBER>
 * 1: Magazine class <STRING>
 * 2: Mode to select (default: "", the first mode) <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [7102, "itc_land_g155hex", "prox"] call itc_land_tablet_fnc_bcsFillFuzes
 *
 * Public: No
 */

params ["_idc", "_magazine", ["_selectedMode", ""]];

private _fuze = configFile >> "ITC_Land_CfgFuzes" >> getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_fuze");
private _modes = getArray (_fuze >> "modes");
[_idc, getArray (_fuze >> "modeDesc"), (_modes find _selectedMode) max 0, _modes] call FUNC(fillComboBox);
