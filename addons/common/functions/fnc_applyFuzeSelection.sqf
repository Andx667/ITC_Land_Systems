#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Handles a fuze combo box selection: stores the selected index, mode and description on the
 * vehicle and shows the time input only for time fuzes.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Selected index <NUMBER>
 * 2: IDC of the fuze combo box <NUMBER>
 * 3: IDC of the time label <NUMBER>
 * 4: IDC of the time edit box <NUMBER>
 * 5: Vehicle variable holding the last entered fuze time <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, 2, 86004, 86005, 86006, "itc_land_fuzeTime"] call itc_land_common_fnc_applyFuzeSelection
 *
 * Public: No
 */

params ["_vehicle", "_index", "_comboIdc", "_timeLabelIdc", "_timeEditIdc", "_timeVariable"];

private _fuzeMode = lbData [_comboIdc, _index];
_vehicle setVariable ["itc_land_selectedFuzeIndex", _index, true];
_vehicle setVariable ["itc_land_selectedFuzeMode", _fuzeMode, true];
_vehicle setVariable ["itc_land_selectedFuzeDesc", lbText [_comboIdc, _index], true];

private _isTimeFuze = _fuzeMode == "time";
[[_timeLabelIdc, _timeEditIdc], _isTimeFuze] call FUNC(ctrlShowMany);
if (_isTimeFuze) then {
    ctrlSetText [_timeEditIdc, format ["%1", _vehicle getVariable [_timeVariable, 0]]];
};
