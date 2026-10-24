#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The classic ammunition handler's APPLY SETTINGS: applies the dialog's fuze, guidance and count
 * (sphammohandler_fnc_applyLoaderSettings), shows the applied settings in the readout and enables
 * the Load button.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_sphammohandler_fnc_applySettings
 *
 * Public: No
 */

private _vehicle = [] call EFUNC(common,getCurVehicle);
private _magazine = (_vehicle getVariable ["itc_land_currentMagInfo", [0, ""]]) param [1, ""];

// the fuze shown, also when it was never changed
[_vehicle, _magazine, lbCurSel 86004] call EFUNC(common,setFuzeSelection);
private _settings = [
    _vehicle,
    parseNumber (ctrlText 86006),
    [parseNumber (ctrlText 86008), parseNumber (ctrlText 86024)],
    ctrlText 86013,
    parseNumber (ctrlText 86015),
    parseNumber (ctrlText 86022)
] call FUNC(applyLoaderSettings);
[] call FUNC(updateStatus);

_settings params ["_round", "_fuze", "_guidance"];
// a laser code that was none shows the one used
if ((_guidance # 1) in ["laser_coded", "laser_coded_2"]) then {
    ctrlSetText [86008, str (_vehicle getVariable ["itc_land_guidance_laserCode", 1111])];
};
if ((_guidance # 1) == "laser_coded_2") then {
    ctrlSetText [86024, str (_vehicle getVariable ["itc_land_guidance_laserCode_2", 1111])];
};
ctrlSetText [86019, _round # 0];
ctrlSetText [86018, _fuze # 0];
ctrlSetText [86017, _guidance # 0];
ctrlSetText [86020, [str (_round # 3), "-- N/A --"] select ((_round # 3) < 1)];

ctrlEnable [86010, true];
ctrlSetFocus ((findDisplay 86000) displayCtrl 86010);
