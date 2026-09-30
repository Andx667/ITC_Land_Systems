#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Applies the selected fuze mode to the vehicle: stores the value the fuze will use
 * (proximity height, time or delay) and builds the text shown in the interface.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Fuze mode, one of "pd", "prox", "time", "delay" <STRING>
 * 2: Fuze description shown in the mode list <STRING>
 * 3: Fuze class in ITC_Land_CfgFuzes <STRING>
 * 4: Fuze time entered by the user, only used by "time" <NUMBER>
 * 5: Vehicle variable that remembers the entered fuze time for the interface <STRING>
 *
 * Return Value:
 * [display text, stored fuze value] <ARRAY>
 *
 * Example:
 * [_vehicle, "time", "TIME", "mof35_mod1", 12, "itc_land_fuzeTime"] call itc_land_common_fnc_resolveFuzeSetting
 *
 * Public: No
 */

params ["_vehicle", "_mode", "_description", "_fuze", "_time", "_timeVariable"];

private _text = _description;
switch (_mode) do {
    case "prox": {
        private _height = getNumber (configFile >> "ITC_Land_CfgFuzes" >> _fuze >> "proxHOB");
        _vehicle setVariable ["itc_land_fuzeValues", _height, true];
        _text = format ["%1: %2m", _description, _height];
    };
    case "time": {
        _vehicle setVariable [_timeVariable, _time, true];
        _vehicle setVariable ["itc_land_fuzeValues", _time, true];
        _text = format ["%1: %2s", _description, _time];
    };
    case "delay": {
        _vehicle setVariable ["itc_land_fuzeValues", 0.005, true];
    };
};

[_text, _vehicle getVariable ["itc_land_fuzeValues", 0]]
