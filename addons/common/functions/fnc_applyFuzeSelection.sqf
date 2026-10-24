#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Handles a classic fuze combo box selection: selects the fuze mode (setFuzeSelection) and shows
 * the time input only for time fuzes.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Magazine class name <STRING>
 * 2: Selected index <NUMBER>
 * 3: IDC of the time label <NUMBER>
 * 4: IDC of the time edit box <NUMBER>
 * 5: Vehicle variable holding the last entered fuze time <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "itc_land_155mm_HE", 2, 86005, 86006, "itc_land_fuzeTime"] call itc_land_common_fnc_applyFuzeSelection
 *
 * Public: No
 */

params ["_vehicle", "_magazine", "_index", "_timeLabelIdc", "_timeEditIdc", "_timeVariable"];

private _isTimeFuze = ([_vehicle, _magazine, _index] call FUNC(setFuzeSelection)) == "time";
[[_timeLabelIdc, _timeEditIdc], _isTimeFuze] call FUNC(ctrlShowMany);
if (_isTimeFuze) then {
    ctrlSetText [_timeEditIdc, format ["%1", _vehicle getVariable [_timeVariable, 0]]];
};
