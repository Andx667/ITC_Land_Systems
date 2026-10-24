#include "..\script_component.hpp"
#include "apps\bcs\bcsDefines.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's BCS actions, as the classic BCS pages' (the form holds the values the page
 * sent, see tablet_fnc_webReceive; tablet_fnc_webViewBcs shows the result):
 *   bcsNewMission, bcsMission i     a new fire mission, or the selected one on its page
 *   bcsSettingsSave                 alert to splash, mission code and number
 *   bcsSetupSave/AddGun/RemoveGun/Link   battery callsign and type, guns by hand or linked
 *   bcsLocAdd/Remove                location stores
 *   bcsNmLoad/Save                  the target: a known point's grid, then on to the engagement
 *   bcsEngAmmo/Back/Save            the engagement: round (its fuzes), sheaf, fire orders
 *   bcsSolStep d, bcsAdjGun i, bcsShot, bcsSendAdj/Ffe, bcsAdjust, bcsSolBack, bcsEom, bcsEomSave
 *                                 solutions: one back or on, the adjusting gun, SHOT, fire commands
 *                                 (adjust fire with one round), end of mission
 *   bcsEngSheaf, bcsNmType        a choice that changes the page (only stored)
 *   bcsAdjSave/Back                 an adjustment to the target
 * The BCS data changes go through the tablet_fnc_bcs* functions the classic pages use as well.
 *
 * Arguments:
 * 0: Vehicle (the tablet's page is kept on it) <OBJECT>
 * 1: App ("bcs") <STRING>
 * 2: Action <STRING>
 * 3: Value <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "bcs", "bcsNewMission", nil] call itc_land_tablet_fnc_webActionBcs
 *
 * Public: No
 */

params ["_vehicle", "_app", "_action", "_value"];

private _form = GVAR(web) get "form";
private _setPage = {_vehicle setVariable [QGVAR(page), _this]};
private _mission = GVAR(bcs_missions) param [GVAR(bcs_mission_index), []];

switch (_action) do {
    case "bcsAdjGun": {
        // stored with the message: the adjusting gun the page marks and SEND ADJ sends
    };
    case "bcsNewMission": {
        private _ident = GENIDENT;
        GVAR(bcs_missions) pushBack EMPTYMISSION(_ident);
        GVAR(bcs_mission_index) = (count GVAR(bcs_missions)) - 1;
        "newMission" call _setPage;
    };
    case "bcsMission": {
        if (_value isEqualType 0 && {_value >= 0} && {_value < count GVAR(bcs_missions)}) then {
            GVAR(bcs_mission_index) = floor _value;
            ((GVAR(bcs_missions) # GVAR(bcs_mission_index)) # 1) call _setPage;
        };
    };

    case "bcsSettingsSave": {
        // seconds before impact, more than 0 (at 0 SPLASH would never show); nothing is saved until it is valid
        private _splashText = ["splash"] call FUNC(webFormValue);
        if (!(_splashText regexMatch "\s*\d+(\.\d+)?\s*") || {parseNumber _splashText <= 0}) exitWith {
            [LLSTRING(Bcs_InvalidSplashTime), "bad"] call FUNC(webNotice);
        };
        GVAR(bcs_splash_time) = parseNumber _splashText;
        GVAR(bcs_mission_code) = ["code"] call FUNC(webFormValue);
        GVAR(bcs_mission_start) = parseNumber (["start"] call FUNC(webFormValue));
        [LLSTRING(WebSaved)] call FUNC(webNotice);
    };

    case "bcsSetupSave": {
        private _types = GVAR(web) getOrDefault ["batteryTypes", []];
        private _type = ["type", "index"] call FUNC(webFormValue);
        GVAR(bcs_bty_name) = ["callsign"] call FUNC(webFormValue);
        if (_type >= 0 && {_type < count _types}) then {
            GVAR(bcs_bty_type) = [_type, _types # _type];
        };
        [LLSTRING(WebSaved)] call FUNC(webNotice);
    };
    case "bcsSetupAddGun": {
        private _num = ["num"] call FUNC(webFormValue);
        [_num, ["grid"] call FUNC(webFormValue), parseNumber (["elev"] call FUNC(webFormValue)), parseNumber (["dir"] call FUNC(webFormValue))] call FUNC(bcsSaveGun);
        [format [LLSTRING(WebGunSaved), _num]] call FUNC(webNotice);
        _form set ["num", ["gun"] call FUNC(bcsNextId)];
        [] call FUNC(webFormChanged);
    };
    case "bcsSetupRemoveGun": {
        private _gun = ["gun", "index"] call FUNC(webFormValue);
        if (_gun >= 0 && {_gun < count GVAR(bcs_bty_guns)}) then {
            GVAR(bcs_bty_guns) deleteAt _gun;
            _form set ["gun", -1];
            _form set ["num", ["gun"] call FUNC(bcsNextId)];
            [] call FUNC(webFormChanged);
        };
    };
    case "bcsSetupLink": {
        private _num = [(GVAR(web) getOrDefault ["linkable", []]) param [["link", "index"] call FUNC(webFormValue), objNull]] call FUNC(bcsLinkGun);
        if (_num == "") exitWith {
            [LLSTRING(Bcs_NoGunsToLink), "warn"] call FUNC(webNotice);
        };
        [format [LLSTRING(WebGunSaved), _num]] call FUNC(webNotice);
        _form set ["link", 0];
        _form set ["num", ["gun"] call FUNC(bcsNextId)];
        [] call FUNC(webFormChanged);
    };

    case "bcsLocAdd": {
        private _id = ["id"] call FUNC(webFormValue);
        [_id, ["grid"] call FUNC(webFormValue), parseNumber (["elev"] call FUNC(webFormValue)), (["friendly", "index"] call FUNC(webFormValue)) == 1] call FUNC(bcsSaveLocation);
        [format [LLSTRING(WebPointSaved), _id]] call FUNC(webNotice);
        _form set ["id", ["point"] call FUNC(bcsNextId)];
        [] call FUNC(webFormChanged);
    };
    case "bcsLocRemove": {
        private _location = ["loc", "index"] call FUNC(webFormValue);
        if (_location >= 0 && {_location < count GVAR(bcs_locations)}) then {
            GVAR(bcs_locations) deleteAt _location;
            _form set ["loc", -1];
        };
    };

    case "bcsNmLoad": {
        private _point = GVAR(bcs_locations) param [["kp", "index"] call FUNC(webFormValue), []];
        if (_point isEqualTo []) exitWith {};
        _form set ["in0", (_point # 1) splitString " " joinString ""];
        _form set ["in1", str (_point # 3)];
        [] call FUNC(webFormChanged);
    };
    case "bcsNmSave": {
        if (_mission isEqualTo []) exitWith {};
        private _inputs = ["in0", "in1", "in2", "in3"] apply {[_x] call FUNC(webFormValue)};
        // stay on the page without a target the solutions can use
        if !([_mission, ["name"] call FUNC(webFormValue), ["type", "index"] call FUNC(webFormValue), ["kp", "index"] call FUNC(webFormValue), _inputs] call FUNC(bcsSetTarget)) exitWith {
            [LLSTRING(Bcs_InvalidTarget), "bad"] call FUNC(webNotice);
        };
        "engageMission" call _setPage;
    };

    case "bcsEngAmmo": {
        // the fuze list follows the round
        _form set ["fuze", 0];
        [] call FUNC(webFormChanged);
    };
    case "bcsEngBack": {
        if (_mission isEqualTo []) exitWith {};
        _mission set [1, "newMission"];
        "newMission" call _setPage;
    };
    case "bcsEngSave": {
        if (_mission isEqualTo []) exitWith {};
        private _ammoIndex = ["ammo", "index"] call FUNC(webFormValue);
        private _modes = getArray (([(GVAR(web) getOrDefault ["shellTypes", []]) param [_ammoIndex max 0, ""]] call EFUNC(common,getFuzeConfig)) >> "modes");
        if !([
            _mission, ["sheaf", "index"] call FUNC(webFormValue), (["quick", "index"] call FUNC(webFormValue)) == 1,
            ["dir"] call FUNC(webFormValue), parseNumber (["length"] call FUNC(webFormValue)),
            _ammoIndex, parseNumber (["count"] call FUNC(webFormValue)), _modes param [["fuze", "index"] call FUNC(webFormValue), ""]
        ] call FUNC(bcsSetEngagement)) exitWith {
            [LLSTRING(Bcs_NoAmmoSelected), "bad"] call FUNC(webNotice);
        };
        "solutionMission" call _setPage;
    };

    case "bcsSolStep": {
        // SLN- (-1) / SLN+ (1)
        private _step = [_value] param [0, 0, [0]];
        if (_mission isEqualTo [] || {!(_step in [-1, 1])}) exitWith {};
        private _count = count ((GVAR(web) get "solutions") # 0);
        _mission set [4, ((_mission # 4) + _step) min (_count - 1) max 0];
    };
    case "bcsSolBack": {
        if (_mission isEqualTo []) exitWith {};
        _mission set [1, "engageMission"];
        "engageMission" call _setPage;
    };
    case "bcsAdjust": {
        if (_mission isEqualTo []) exitWith {};
        "adjustMission" call _setPage;
    };
    case "bcsShot": {
        (GVAR(web) get "solutions") params ["_btySolutions"];
        private _solution = _btySolutions param [(_mission param [4, 0]) min (count _btySolutions - 1) max 0, []];
        if (_solution isEqualTo []) exitWith {};
        [_mission # 0, _solution # 4] call FUNC(bcsShot);
    };
    case "bcsSendAdj";
    case "bcsSendFfe": {
        if (_mission isEqualTo []) exitWith {};
        ([_mission, GVAR(web) get "solutions", _action == "bcsSendFfe", ["gun", "index"] call FUNC(webFormValue)] call FUNC(bcsSendFireData)) params ["_report", "_kind"];
        [_report joinString "  -  ", _kind] call FUNC(webNotice);
    };
    case "bcsEom";
    case "bcsEomSave": {
        if (_mission isEqualTo []) exitWith {};
        [_action == "bcsEomSave"] call FUNC(bcsEndMission);
        "locStores" call _setPage;
    };

    case "bcsAdjBack": {
        if (_mission isEqualTo []) exitWith {};
        "solutionMission" call _setPage;
    };
    case "bcsAdjSave": {
        if (_mission isEqualTo []) exitWith {};
        [
            _mission, ["ot"] call FUNC(webFormValue),
            parseNumber (["ad"] call FUNC(webFormValue)), parseNumber (["lr"] call FUNC(webFormValue)), parseNumber (["ud"] call FUNC(webFormValue))
        ] call FUNC(bcsAdjustTarget);
        "solutionMission" call _setPage;
    };
};
