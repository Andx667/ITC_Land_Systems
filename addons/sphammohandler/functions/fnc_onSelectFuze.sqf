#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * RscListBox onLBSelChanged handler for the SPH ammo-loader's fuze combobox. Stores
 * the newly selected fuze index, mode and description on the vehicle, and shows or
 * hides the timed-fuze delay input field depending on whether the selected fuze mode
 * is "time".
 *
 * Arguments:
 * 0: The listbox control that triggered the selection change <Control>
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

params ["_control", "_index"];

[[] call EFUNC(common,getCurVehicle), _index, 86004, 86005, 86006, "itc_land_fuzeTime"] call EFUNC(common,applyFuzeSelection);
