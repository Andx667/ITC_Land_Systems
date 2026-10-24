#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Selects a fuze mode of a magazine for the vehicle: stores its index, mode and name on the
 * vehicle (itc_land_selectedFuzeIndex / Mode / Desc), where the ammunition handler, the FCI and
 * resolveFuzeSetting read it. An index the magazine's fuze does not have selects its first mode.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Magazine class name <STRING>
 * 2: Fuze mode index <NUMBER>
 *
 * Return Value:
 * Fuze mode, "" for a magazine without an ITC fuze <STRING>
 *
 * Example:
 * [_vehicle, "itc_land_155mm_HE", 2] call itc_land_common_fnc_setFuzeSelection
 *
 * Public: No
 */

params ["_vehicle", "_magazine", "_index"];

private _fuzeConfig = [_magazine] call FUNC(getFuzeConfig);
private _modes = getArray (_fuzeConfig >> "modes");
if (!(_index isEqualType 0) || {_index < 0} || {_index >= count _modes}) then {_index = 0};
private _mode = _modes param [_index, ""];
_vehicle setVariable ["itc_land_selectedFuzeIndex", _index, true];
_vehicle setVariable ["itc_land_selectedFuzeMode", _mode, true];
_vehicle setVariable ["itc_land_selectedFuzeDesc", getArray (_fuzeConfig >> "modeDesc") param [_index, ""], true];
_mode
