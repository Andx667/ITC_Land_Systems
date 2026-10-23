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
 *
 * Arguments:
 * 0: Vehicle (the tablet's page is kept on it) <OBJECT>
 * 1: Action <STRING>
 * 2: Value <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "bcsNewMission", nil] call itc_land_tablet_fnc_webActionBcs
 *
 * Public: No
 */

params ["_vehicle", "_action", "_value"];

private _form = GVAR(web) get "form";
// a field as text, a select box's or list's index (-1 for none)
private _text = {
    params ["_id"];
    private _field = _form getOrDefault [_id, ""];
    [str _field, _field] select (_field isEqualType "")
};
private _index = {
    params ["_id"];
    private _field = _form getOrDefault [_id, -1];
    [-1, floor _field] select (_field isEqualType 0)
};
private _setPage = {_vehicle setVariable [QGVAR(page), _this]};
private _mission = GVAR(bcs_missions) param [GVAR(bcs_mission_index), []];

// a step through the solutions is SLN- / SLN+
if (_action == "bcsSolStep") then {_action = ["", "bcsSolDown", "bcsSolUp"] select ([0, -1, 1] find _value max 0)};

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
        private _splashText = ["splash"] call _text;
        if (!(_splashText regexMatch "\s*\d+(\.\d+)?\s*") || {parseNumber _splashText <= 0}) exitWith {
            [LLSTRING(Bcs_InvalidSplashTime), "bad"] call FUNC(webNotice);
        };
        GVAR(bcs_splash_time) = parseNumber _splashText;
        GVAR(bcs_mission_code) = ["code"] call _text;
        GVAR(bcs_mission_start) = parseNumber (["start"] call _text);
        [LLSTRING(WebSaved)] call FUNC(webNotice);
    };

    case "bcsSetupSave": {
        private _types = GVAR(web) getOrDefault ["batteryTypes", []];
        private _type = ["type"] call _index;
        GVAR(bcs_bty_name) = ["callsign"] call _text;
        if (_type >= 0 && {_type < count _types}) then {
            GVAR(bcs_bty_type) = [_type, _types # _type];
        };
        [LLSTRING(WebSaved)] call FUNC(webNotice);
    };
    case "bcsSetupAddGun": {
        private _num = ["num"] call _text;
        private _posStr = ["grid"] call _text;
        private _elev = parseNumber (["elev"] call _text);
        private _pos = ([_posStr, false] call ace_common_fnc_getMapPosFromGrid) vectorAdd [0, 0, _elev];
        private _gunData = [_num, _posStr, _pos, _elev, parseNumber (["dir"] call _text), GVAR(bcs_bty_name)];
        private _gun = GVAR(bcs_bty_guns) findIf {_x # 0 == _num};
        if (_gun == -1) then {GVAR(bcs_bty_guns) pushBack _gunData} else {GVAR(bcs_bty_guns) set [_gun, _gunData]};
        [format [LLSTRING(WebGunSaved), _num]] call FUNC(webNotice);
        _form set ["num", [] call FUNC(bcsNextGunNumber)];
        GVAR(web) set ["formRev", (GVAR(web) get "formRev") + 1];
    };
    case "bcsSetupRemoveGun": {
        private _gun = ["gun"] call _index;
        if (_gun >= 0 && {_gun < count GVAR(bcs_bty_guns)}) then {
            GVAR(bcs_bty_guns) deleteAt _gun;
            _form set ["gun", -1];
            _form set ["num", [] call FUNC(bcsNextGunNumber)];
            GVAR(web) set ["formRev", (GVAR(web) get "formRev") + 1];
        };
    };
    case "bcsSetupLink": {
        private _gunVehicle = (GVAR(web) getOrDefault ["linkable", []]) param [["link"] call _index, objNull];
        if (!alive _gunVehicle || {_gunVehicle in (GVAR(bcs_bty_guns) apply {_x param [6, objNull]})}) exitWith {
            [LLSTRING(Bcs_NoGunsToLink), "warn"] call FUNC(webNotice);
        };
        // the next free gun number; position, elevation and direction come from the vehicle
        private _num = [] call FUNC(bcsNextGunNumber);
        GVAR(bcs_bty_guns) append ([[[_num, "", [0, 0, 0], 0, 0, GVAR(bcs_bty_name), _gunVehicle]]] call EFUNC(bcs,refreshLinkedGuns));
        [format [LLSTRING(WebGunSaved), _num]] call FUNC(webNotice);
        _form set ["link", 0];
        _form set ["num", [] call FUNC(bcsNextGunNumber)];
        GVAR(web) set ["formRev", (GVAR(web) get "formRev") + 1];
    };

    case "bcsLocAdd": {
        private _num = ["id"] call _text;
        private _posStr = ["grid"] call _text;
        private _elev = parseNumber (["elev"] call _text);
        private _pos = ([_posStr, false] call ace_common_fnc_getMapPosFromGrid) vectorAdd [0, 0, _elev];
        // the checkbox stored as the classic list's "no" / "yes"
        private _locData = [_num, _posStr, _pos, _elev, ["no", "yes"] select ((["friendly"] call _index) == 1)];
        private _location = GVAR(bcs_locations) findIf {_x # 0 == _num};
        if (_location == -1) then {GVAR(bcs_locations) pushBack _locData} else {GVAR(bcs_locations) set [_location, _locData]};
        [format [LLSTRING(WebPointSaved), _num]] call FUNC(webNotice);
        _form set ["id", [] call FUNC(webNextPointId)];
        GVAR(web) set ["formRev", (GVAR(web) get "formRev") + 1];
    };
    case "bcsLocRemove": {
        private _location = ["loc"] call _index;
        if (_location >= 0 && {_location < count GVAR(bcs_locations)}) then {
            GVAR(bcs_locations) deleteAt _location;
            _form set ["loc", -1];
        };
    };

    case "bcsNmLoad": {
        private _point = GVAR(bcs_locations) param [["kp"] call _index, []];
        if (_point isEqualTo []) exitWith {};
        _form set ["in0", _point # 1];
        _form set ["in1", str (_point # 3)];
        GVAR(web) set ["formRev", (GVAR(web) get "formRev") + 1];
    };
    case "bcsNmSave": {
        if (_mission isEqualTo []) exitWith {};
        private _typeIndex = ["type"] call _index;
        private _kpi = ["kp"] call _index;
        private _targetPage = [_typeIndex, _kpi, ["in0"] call _text, ["in1"] call _text, ["in2"] call _text, ["in3"] call _text];
        // Without its input a target type has no position: Grid needs a grid, Shift and Polar a known point,
        // QuickLay the battery's guns. Stay on the page instead of saving a mission the solutions cannot use.
        private _validInput = switch (_typeIndex) do {
            case 0: {(["in0"] call _text) regexMatch "^([0-9][0-9]){2,5}$"};
            case 1;
            case 2: {_kpi > -1 && {_kpi < count GVAR(bcs_locations)}};
            case 3: {GVAR(bcs_bty_guns) isNotEqualTo []};
            default {false};
        };
        private _targetPos = if (_validInput) then {_targetPage call EFUNC(bcs,calculateTarget)} else {[]};
        if !(_targetPos isEqualTypeArray [0, 0, 0]) exitWith {
            [LLSTRING(Bcs_InvalidTarget), "bad"] call FUNC(webNotice);
        };
        _targetPage set [6, _targetPos];
        _mission set [2, _targetPage];
        _mission set [0, ["name"] call _text];
        _mission set [1, "engageMission"];
        "engageMission" call _setPage;
    };

    case "bcsEngAmmo": {
        // the fuze list follows the round
        _form set ["fuze", 0];
        GVAR(web) set ["formRev", (GVAR(web) get "formRev") + 1];
    };
    case "bcsEngBack": {
        if (_mission isEqualTo []) exitWith {};
        _mission set [1, "newMission"];
        "newMission" call _setPage;
    };
    case "bcsEngSave": {
        if (_mission isEqualTo []) exitWith {};
        private _shellTypes = GVAR(web) getOrDefault ["shellTypes", []];
        private _ammoIndex = ["ammo"] call _index;
        private _magType = _shellTypes param [_ammoIndex, ""];
        if (_ammoIndex < 0 || {_magType == ""}) exitWith {
            [LLSTRING(Bcs_NoAmmoSelected), "bad"] call FUNC(webNotice);
        };
        private _modes = getArray (configFile >> "ITC_Land_CfgFuzes" >> getText (configFile >> "CfgMagazines" >> _magType >> "itc_land_fuze") >> "modes");
        private _sheafDirection = [["dir"] call _text, [GVAR(bcs_bty_type) # 1] call EFUNC(common,getMilSystem)] call EFUNC(common,parseMils);
        // Quick Sheaf from its checkbox: the classic list's index, 0 On, 1 Off
        _mission set [3, [
            (["sheaf"] call _index) max 0, [1, 0] select ((["quick"] call _index) == 1), _sheafDirection, parseNumber (["length"] call _text),
            _ammoIndex, _magType, (floor parseNumber (["count"] call _text)) max 1, _modes param [["fuze"] call _index, ""]
        ]];
        _mission set [1, "solutionMission"];
        "solutionMission" call _setPage;
    };

    case "bcsSolUp": {
        if (_mission isEqualTo []) exitWith {};
        private _count = count ((GVAR(web) get "solutions") # 0);
        _mission set [4, ((_mission # 4) + 1) min (_count - 1) max 0];
    };
    case "bcsSolDown": {
        if (_mission isEqualTo []) exitWith {};
        _mission set [4, ((_mission # 4) - 1) max 0];
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
        _mission params ["_ident", "", "_targetPage", "_engagePage", "_curSolution"];
        _engagePage params ["", "", "", "", "", ["_magazineType", ""], ["_roundCount", 1], ["_fuzeMode", ""]];
        (GVAR(web) get "solutions") params ["_btySolutions", "_gunSolutions"];
        // the FDC's datalink ID is the origin; the BCS connects the player when it opens
        private _origin = ACE_player getVariable [QEGVAR(datalink,id), ""];
        if (_origin == "") exitWith {
            [LLSTRING(Bcs_DatalinkNotConnected), "warn"] call FUNC(webNotice);
        };
        private _batterySolution = _btySolutions param [_curSolution min (count _btySolutions - 1) max 0, []];
        if (_batterySolution isEqualTo []) exitWith {
            [LLSTRING(Bcs_NoSolutions), "bad"] call FUNC(webNotice);
        };
        private _ffe = _action == "bcsSendFfe";
        private _phase = ["ADJ", "FFE"] select _ffe;
        // adjust fire: the adjusting gun fires one round per correction; the count is for fire for effect
        if (!_ffe) then {_roundCount = 1};
        private _selectedGun = _gunSolutions param [(["gun"] call _index) max 0, []];
        private _lines = if (_ffe) then {_gunSolutions} else {[_selectedGun] select {_x isNotEqualTo []}};
        private _sent = [];
        private _notLinked = [];
        private _noSolution = [];
        {
            _x params ["_num", "_gunSolutionList"];
            private _gunIndex = GVAR(bcs_bty_guns) findIf {_x # 0 == _num};
            private _gunVehicle = (GVAR(bcs_bty_guns) param [_gunIndex, []]) param [6, objNull];
            private _id = if (alive _gunVehicle) then {_gunVehicle getVariable [QEGVAR(datalink,id), ""]} else {""};
            private _line = [_gunSolutionList, _batterySolution] call EFUNC(bcs,matchGunSolution);
            switch (true) do {
                case (_id == ""): {_notLinked pushBack _num};
                case (_line isEqualTo []): {_noSolution pushBack _num};
                default {
                    [_id, _origin, "fdc", "fireData", [_ident, _phase, _line, _magazineType, _roundCount, _fuzeMode, _targetPage param [6, []]]] call EFUNC(datalink,transmit);
                    _sent pushBack _num;
                };
            };
        } forEach _lines;
        private _report = [format [LLSTRING(Bcs_SentTo), _ident, _phase, [_sent joinString ", ", "-"] select (_sent isEqualTo [])]];
        if (_notLinked isNotEqualTo []) then {_report pushBack format [LLSTRING(Bcs_NotLinked), _notLinked joinString ", "]};
        if (_noSolution isNotEqualTo []) then {_report pushBack format [LLSTRING(Bcs_NoSolutionFor), _noSolution joinString ", "]};
        [_report joinString "  -  ", ["", "warn"] select (_notLinked isNotEqualTo [] || {_noSolution isNotEqualTo []})] call FUNC(webNotice);
    };
    case "bcsEom";
    case "bcsEomSave": {
        if (_mission isEqualTo []) exitWith {};
        _mission params ["_ident", "", "_targetPage"];
        // end of mission for the linked guns: their fire orders for it are cleared
        private _origin = ACE_player getVariable [QEGVAR(datalink,id), ""];
        if (_origin != "") then {
            {
                private _gunVehicle = _x param [6, objNull];
                private _id = if (alive _gunVehicle) then {_gunVehicle getVariable [QEGVAR(datalink,id), ""]} else {""};
                if (_id != "") then {
                    [_id, _origin, "fdc", "endMission", [_ident]] call EFUNC(datalink,transmit);
                };
            } forEach GVAR(bcs_bty_guns);
        };
        if (_action == "bcsEomSave") then {
            private _tgtPos = _targetPage param [6, [0, 0, 0]];
            GVAR(bcs_locations) pushBack [_ident, [_tgtPos] call EFUNC(common,posToGrid), _tgtPos, round (_tgtPos # 2), false];
        };
        GVAR(bcs_missions) deleteAt GVAR(bcs_mission_index);
        "locStores" call _setPage;
    };

    case "bcsAdjBack": {
        if (_mission isEqualTo []) exitWith {};
        "solutionMission" call _setPage;
    };
    case "bcsAdjSave": {
        if (_mission isEqualTo []) exitWith {};
        private _targetPage = _mission # 2;
        private _ot = [["ot"] call _text, [GVAR(bcs_bty_type) # 1] call EFUNC(common,getMilSystem)] call EFUNC(common,parseMils);
        private _tgtPos = [_targetPage # 6, _ot, parseNumber (["ad"] call _text), parseNumber (["lr"] call _text), parseNumber (["ud"] call _text)] call EFUNC(bcs,adjustGrid);
        // the observer's direction stays for the next correction
        if (isNil QGVAR(bcs_lastOT)) then {GVAR(bcs_lastOT) = createHashMap};
        GVAR(bcs_lastOT) set [_mission # 0, ["ot"] call _text];
        _targetPage set [6, _tgtPos];
        _mission set [2, _targetPage];
        "solutionMission" call _setPage;
    };
};
