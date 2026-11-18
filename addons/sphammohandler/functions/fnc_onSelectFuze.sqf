#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * RscListBox onLBSelChanged handler for the SPH ammo-loader's fuze combobox. Stores
 * the newly selected fuze index, mode and description on the vehicle, and shows or
 * hides the timed-fuze delay input field depending on whether the selected fuze mode
 * is "time".
 *
 * Arguments:
 * 0: The listbox control that triggered the selection change (or its IDC when called from code) <Control or Number>
 * 1: Index of the newly selected fuze listbox item <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [86004, 0] call itc_land_sphammohandler_fnc_onSelectFuze
 *
 * Public: No
 */

params [["_control", controlNull, [controlNull, 0]], ["_index", 0, [0]]];

private _vehicle = [] call EFUNC(common,getCurVehicle);
[_vehicle, (_vehicle getVariable [QGVAR(currentMagInfo), [0, ""]]) param [1, ""], _index, 86005, 86006, QGVAR(fuzeTime)] call EFUNC(common,applyFuzeSelection);
