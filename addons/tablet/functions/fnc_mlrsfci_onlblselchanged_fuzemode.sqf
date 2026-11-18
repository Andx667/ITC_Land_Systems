#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Listbox selection-changed handler for the MLRS FCI fuze mode selector.
 * Stores the selected fuze index/mode/description on the current vehicle
 * and shows/hides and updates the fuze time text field depending on
 * whether the selected fuze mode is a "time" fuze.
 *
 * Arguments:
 * 0: Listbox control that triggered the event (or its IDC when called from code) <Control or Number>
 * 1: Selected listbox index <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [(_this select 0), (_this select 1)] call itc_land_tablet_fnc_mlrsfci_onlblselchanged_fuzemode
 *
 * Public: No
 */

params [["_control", controlNull, [controlNull, 0]], ["_index", 0, [0]]];
ITC_CURVEHICLE

[_vehicle, lbData [2402, lbCurSel 2402], _index, 1905, 1906, QGVAR(mlrsfci_fuzeTime)] call EFUNC(common,applyFuzeSelection);
