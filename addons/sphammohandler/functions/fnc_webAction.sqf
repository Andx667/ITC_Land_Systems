#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The ammunition handler's actions in HTML (sphammohandler_fnc_webView), as the classic
 * dialog's; the form holds the values the page sent (tablet_fnc_webReceive):
 *   ahAmmo        the round to prepare (its fuze modes follow it)
 *   ahCharge d    one charge up (1) or down (-1)
 *   ahFuze        another fuze mode
 *   ahApply       the settings the loader works with (sphammohandler_fnc_applyLoaderSettings)
 *   ahLoad        load / unload, a mortar prepare / fire (sphammohandler_fnc_loadGun)
 *   ahStow        a mortar: stow the prepared round
 *   ahFdcOrders   fill in the FDC's round, charge, fuze, count and GPS target
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Action <STRING>
 * 2: Value <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player, "ahLoad", nil] call itc_land_sphammohandler_fnc_webAction
 *
 * Public: No
 */

params ["_vehicle", "_action", "_value"];

private _form = EGVAR(tablet,web) get "form";
private _mortar = getNumber (configOf _vehicle >> "itc_land" >> "loaderType") == 3;
private _status = (_vehicle getVariable ["itc_land_ammoHandler_status", [0, 0, LSTRING(Status_Waiting)]]) # 0;
private _ammoList = EGVAR(tablet,web) getOrDefault ["ammoList", []];
private _magazine = (_vehicle getVariable ["itc_land_currentMagInfo", [0, ""]]) param [1, ""];
private _setRound = {
    params ["_index"];
    _magazine = _ammoList # _index;
    _vehicle setVariable ["itc_land_currentMagInfo", [_index, _magazine, configFile >> "CfgMagazines" >> _magazine], true];
    _form set ["ammo", _index];
};

switch (_action) do {
    case "ahAmmo": {
        private _index = ["ammo", "index"] call EFUNC(tablet,webFormValue);
        if (_index < 0 || {_index >= count _ammoList}) exitWith {};
        [_index] call _setRound;
        // the new round's fuzes: the last one if it has it, else the first
        [_vehicle, _magazine, _vehicle getVariable ["itc_land_selectedFuzeIndex", 0]] call EFUNC(common,setFuzeSelection);
        _form set ["fuze", _vehicle getVariable ["itc_land_selectedFuzeIndex", 0]];
        [] call EFUNC(tablet,webFormChanged);
    };
    case "ahCharge": {
        if !(_value in [-1, 1]) exitWith {};
        private _max = getNumber (configFile >> "CfgMagazines" >> _magazine >> "itc_land_maxChargeIndex");
        _vehicle setVariable ["itc_land_currentChargeIndex", (((_vehicle getVariable ["itc_land_currentChargeIndex", 1]) + _value) min _max) max 1, true];
    };
    case "ahFuze": {
        [_vehicle, _magazine, ["fuze", "index"] call EFUNC(tablet,webFormValue)] call EFUNC(common,setFuzeSelection);
    };
    case "ahApply": {
        if (!(_status in [0, 1]) || {_magazine == ""}) exitWith {};
        // the fuze shown, also when it was never changed
        [_vehicle, _magazine, ["fuze", "index"] call EFUNC(tablet,webFormValue)] call EFUNC(common,setFuzeSelection);
        private _settings = [
            _vehicle,
            parseNumber (["time"] call EFUNC(tablet,webFormValue)),
            [parseNumber (["code1"] call EFUNC(tablet,webFormValue)), parseNumber (["code2"] call EFUNC(tablet,webFormValue))],
            ["grid"] call EFUNC(tablet,webFormValue),
            parseNumber (["alt"] call EFUNC(tablet,webFormValue)),
            parseNumber (["count"] call EFUNC(tablet,webFormValue))
        ] call FUNC(applyLoaderSettings);
        // a laser code that was none shows the one used
        private _guidance = _settings # 2 # 1;
        private _codes = [];
        if (_guidance in ["laser_coded", "laser_coded_2"]) then {_codes pushBack ["code1", "itc_land_guidance_laserCode"]};
        if (_guidance == "laser_coded_2") then {_codes pushBack ["code2", "itc_land_guidance_laserCode_2"]};
        {
            _x params ["_id", "_variable"];
            private _used = str (_vehicle getVariable [_variable, 1111]);
            if ((_form getOrDefault [_id, ""]) isNotEqualTo _used) then {
                _form set [_id, _used];
                [] call EFUNC(tablet,webFormChanged);
            };
        } forEach _codes;
    };
    case "ahLoad": {
        [_vehicle] call FUNC(loadGun);
    };
    case "ahStow": {
        if (_mortar) then {[_vehicle, true] call FUNC(loadGun)};
    };
    case "ahFdcOrders": {
        // fill in the FDC's fire orders; the crew still checks them, then APPLY and LOAD, and lays the gun
        private _orders = [_vehicle, _ammoList] call EFUNC(common,getFdcOrders);
        if (_orders isEqualTo createHashMap) exitWith {
            [LLSTRING(NoFdcOrders), "warn"] call EFUNC(tablet,webNotice);
        };
        if ((_orders get "round") == -1) exitWith {
            [format [LLSTRING(FdcRoundMissing), getText (configFile >> "CfgMagazines" >> (_orders get "magazine") >> "displayName")], "bad"] call EFUNC(tablet,webNotice);
        };
        [_orders get "round"] call _setRound;
        _vehicle setVariable ["itc_land_currentChargeIndex", _orders get "charge", true];
        if ((_orders get "fuze") != -1) then {
            [_vehicle, _magazine, _orders get "fuze"] call EFUNC(common,setFuzeSelection);
            _form set ["fuze", _orders get "fuze"];
        };
        if ((_orders get "time") != "") then {_form set ["time", _orders get "time"]};
        if (!_mortar) then {_form set ["count", str (_orders get "count")]};
        if ((_orders get "grid") != "") then {
            _form set ["grid", _orders get "grid"];
            _form set ["alt", _orders get "alt"];
        };
        [] call EFUNC(tablet,webFormChanged);
        [format [LLSTRING(FdcOrdersApplied), _orders get "mission"]] call EFUNC(tablet,webNotice);
    };
};
