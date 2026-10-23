#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The ammunition handler's actions in HTML (sphammohandler_fnc_webView), as the classic
 * dialog's; the form holds the values the page sent (tablet_fnc_webReceive):
 *   ahAmmo        the round to prepare (its fuze modes follow it)
 *   ahCharge d    one charge up (1) or down (-1)
 *   ahFuze        another fuze mode
 *   ahApply       the settings the loader works with (sphammohandler_fnc_applySettings)
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

private _web = EGVAR(tablet,web);
private _form = _web get "form";
private _text = {
    params ["_id"];
    private _field = _form getOrDefault [_id, ""];
    [str _field, _field] select (_field isEqualType "")
};
private _mortar = getNumber (configOf _vehicle >> "itc_land" >> "loaderType") == 3;
private _status = (_vehicle getVariable ["itc_land_ammoHandler_status", [0, 0, LSTRING(Status_Waiting)]]) # 0;
private _ammoList = _web getOrDefault ["ammoList", []];
private _magazine = (_vehicle getVariable ["itc_land_currentMagInfo", [0, ""]]) param [1, ""];
private _fuzeConfig = configFile >> "ITC_Land_CfgFuzes" >> getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_fuze");
// the fuze selection is kept on the vehicle, as by the classic fuze list (common_fnc_applyFuzeSelection)
private _setFuze = {
    params ["_index"];
    _vehicle setVariable ["itc_land_selectedFuzeIndex", _index, true];
    _vehicle setVariable ["itc_land_selectedFuzeMode", getArray (_fuzeConfig >> "modes") param [_index, ""], true];
    _vehicle setVariable ["itc_land_selectedFuzeDesc", getArray (_fuzeConfig >> "modeDesc") param [_index, ""], true];
};

switch (_action) do {
    case "ahAmmo": {
        private _index = _form getOrDefault ["ammo", 0];
        if !(_index isEqualType 0 && {_index >= 0} && {_index < count _ammoList}) exitWith {};
        _magazine = _ammoList # _index;
        _vehicle setVariable ["itc_land_currentMagInfo", [_index, _magazine, configFile >> "CfgMagazines" >> _magazine], true];
        // the new round's fuzes: the last one if it has it, else the first
        _fuzeConfig = configFile >> "ITC_Land_CfgFuzes" >> getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_fuze");
        private _fuze = _vehicle getVariable ["itc_land_selectedFuzeIndex", 0];
        if (_fuze >= count getArray (_fuzeConfig >> "modes")) then {_fuze = 0};
        [_fuze] call _setFuze;
        _form set ["fuze", _fuze];
        _web set ["formRev", (_web get "formRev") + 1];
    };
    case "ahCharge": {
        if !(_value in [-1, 1]) exitWith {};
        private _max = getNumber (configFile >> "CfgMagazines" >> _magazine >> "itc_land_maxChargeIndex");
        _vehicle setVariable ["itc_land_currentChargeIndex", (((_vehicle getVariable ["itc_land_currentChargeIndex", 1]) + _value) min _max) max 1, true];
    };
    case "ahFuze": {
        private _index = _form getOrDefault ["fuze", 0];
        if (_index isEqualType 0 && {_index >= 0}) then {[_index] call _setFuze};
    };
    case "ahApply": {
        if (!(_status in [0, 1]) || {_magazine == ""}) exitWith {};
        _vehicle setVariable ["itc_land_ammoHandler_status", [1, 0, LSTRING(Status_Waiting)], true];
        // the fuze shown, also when it was never changed
        private _fuzeIndex = _form getOrDefault ["fuze", 0];
        [[0, _fuzeIndex] select (_fuzeIndex isEqualType 0)] call _setFuze;
        private _magazineConfig = configFile >> "CfgMagazines" >> _magazine;
        private _charge = _vehicle getVariable ["itc_land_currentChargeIndex", 1];
        private _ammoText = format [LLSTRING(AmmoCharge), getText (_magazineConfig >> "displayNameShort"), _charge];

        private _fuzeMode = _vehicle getVariable ["itc_land_selectedFuzeMode", "pd"];
        private _fuzeDesc = _vehicle getVariable ["itc_land_selectedFuzeDesc", ""];
        ([_vehicle, _fuzeMode, _fuzeDesc, getText (_magazineConfig >> "itc_land_fuze"), parseNumber (["time"] call _text), "itc_land_fuzeTime"] call EFUNC(common,resolveFuzeSetting)) params ["_fuzeText", "_fuzeValues"];

        // guidance: a laser code that is none falls back to the default, and the field shows it
        private _code = {
            params ["_id", "_default"];
            private _number = parseNumber ([_id] call _text);
            if !([_number] call EFUNC(common,isLaserCode)) then {
                _number = _default;
                _form set [_id, str _default];
                _web set ["formRev", (_web get "formRev") + 1];
            };
            _number
        };
        private _guidance = getArray (_magazineConfig >> "itc_land_guidance");
        private _guidanceText = "-- N/A --";
        switch (_guidance param [0, ""]) do {
            case "gps_inertial": {
                private _targetGrid = ["grid"] call _text;
                private _targetAlt = parseNumber (["alt"] call _text);
                _vehicle setVariable ["itc_land_guidance_targetGrid", _targetGrid, true];
                _vehicle setVariable ["itc_land_guidance_targetAlt", _targetAlt, true];
                _vehicle setVariable ["itc_land_guidance_targetPos", [_targetGrid, _targetAlt] call EFUNC(common,gridToPos), true];
                _guidanceText = format ["%1 -- %2", _targetGrid, _targetAlt];
            };
            case "laser_coded": {
                private _laserCode = ["code1", 1111] call _code;
                _vehicle setVariable ["itc_land_guidance_laserCode", _laserCode, true];
                _guidanceText = format [LLSTRING(LaserCode), _laserCode];
            };
            case "laser_coded_2": {
                private _laserCode = ["code1", 1111] call _code;
                private _laserCode2 = ["code2", 1111] call _code;
                _vehicle setVariable ["itc_land_guidance_laserCode", _laserCode, true];
                _vehicle setVariable ["itc_land_guidance_laserCode_2", _laserCode2, true];
                _guidanceText = format [LLSTRING(LaserCodes), _laserCode, _laserCode2];
            };
        };

        // a mortar has no round count: its crew fires every round by hand
        private _roundCount = [parseNumber (["count"] call _text), 0] select _mortar;
        _vehicle setVariable ["itc_land_roundCount", _roundCount, true];
        _vehicle setVariable ["itc_land_roundsFired", 0, true];
        _vehicle setVariable ["itc_land_sphloadersettings", [
            [_ammoText, _magazine, _charge, _roundCount],
            [_fuzeText, _fuzeMode, _fuzeValues],
            [_guidanceText, _guidance param [0, ""]]
        ], true];
    };
    case "ahLoad": {
        [_vehicle] call FUNC(loadGun);
    };
    case "ahStow": {
        if (_mortar) then {[_vehicle, true] call FUNC(loadGun)};
    };
    case "ahFdcOrders": {
        // fill in the FDC's fire orders; the crew still checks them, then APPLY and LOAD, and lays the gun
        (_vehicle getVariable [QEGVAR(bcs,fireData), []]) params [["_mission", ""], "", ["_ordered", ""], "", ["_count", 1], ["_fuzeMode", ""], ["_targetPos", []]];
        if (_mission == "") exitWith {
            [LLSTRING(NoFdcOrders), "warn"] call EFUNC(tablet,webNotice);
        };
        private _index = _ammoList find _ordered;
        if (_index == -1) exitWith {
            [format [LLSTRING(FdcRoundMissing), getText (configFile >> "CfgMagazines" >> _ordered >> "displayName")], "bad"] call EFUNC(tablet,webNotice);
        };
        _vehicle setVariable ["itc_land_currentMagInfo", [_index, _ordered, configFile >> "CfgMagazines" >> _ordered], true];
        _form set ["ammo", _index];
        // the charge of the firing line the FDC sent
        private _line = [_vehicle] call EFUNC(common,getFireSolution);
        private _max = getNumber (configFile >> "CfgMagazines" >> _ordered >> "itc_land_maxChargeIndex");
        _vehicle setVariable ["itc_land_currentChargeIndex", ((parseNumber (_line param [0, "1"])) min _max) max 1, true];
        _fuzeConfig = configFile >> "ITC_Land_CfgFuzes" >> getText (configFile >> "CfgMagazines" >> _ordered >> "itc_land_fuze");
        private _fuze = getArray (_fuzeConfig >> "modes") find _fuzeMode;
        if (_fuze != -1) then {
            [_fuze] call _setFuze;
            _form set ["fuze", _fuze];
            // a time fuze gets the fuze setting of the sent line
            private _fuzeSetting = _line param [10, -1];
            if (_fuzeMode == "time" && {_fuzeSetting >= 0}) then {
                _form set ["time", [_fuzeSetting, 1, 1] call CBA_fnc_formatNumber];
            };
        };
        if (!_mortar) then {_form set ["count", str _count]};
        if ((getArray (configFile >> "CfgMagazines" >> _ordered >> "itc_land_guidance")) param [0, ""] == "gps_inertial" && {_targetPos isEqualTypeArray [0, 0, 0]}) then {
            _form set ["grid", ([_targetPos] call ace_common_fnc_getMapGridFromPos) joinString ""];
            _form set ["alt", str round (_targetPos # 2)];
        };
        _web set ["formRev", (_web get "formRev") + 1];
        [format [LLSTRING(FdcOrdersApplied), _mission]] call EFUNC(tablet,webNotice);
    };
};
