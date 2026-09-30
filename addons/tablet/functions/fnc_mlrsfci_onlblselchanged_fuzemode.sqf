#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Listbox selection-changed handler for the MLRS FCI fuze mode selector.
 * Stores the selected fuze index/mode/description on the current vehicle
 * and shows/hides and updates the fuze time text field depending on
 * whether the selected fuze mode is a "time" fuze.
 *
 * Arguments:
 * 0: Listbox control that triggered the event <Control>
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

params ["_control", "_index"];
ITC_CURVEHICLE

[_vehicle, _index, 1904, 1905, 1906, "itc_land_mlrsfci_fuzeTime"] call EFUNC(common,applyFuzeSelection);
