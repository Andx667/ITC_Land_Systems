#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's BCS, page by page as the classic one (the same data, the actions in
 * tablet_fnc_webActionBcs): settings, battery setup (the battery, its guns by hand or linked over
 * the datalink), the known points, and a fire mission's target, engagement, solutions and
 * adjustment, in the order of a fire mission: call for fire, target, method of engagement,
 * fire commands to the guns (with the message to the observer), adjust fire, fire for effect,
 * end of mission. The sidebar has the pages and the fire missions with SHOT / SPLASH.
 *
 * Arguments:
 * 0: Vehicle (the tablet's page is kept on it) <OBJECT>
 * 1: App ("bcs") <STRING>
 *
 * Return Value:
 * View <HASHMAP>
 *
 * Example:
 * [player, "bcs"] call itc_land_tablet_fnc_webViewBcs
 *
 * Public: No
 */

params ["_vehicle", "_app"];

private _page = _vehicle getVariable [QGVAR(page), "settings"];
// resumed without the app start (a new mission, a respawned player): start the BCS for this player
if (isNil QGVAR(bcs_missions) || {missionNamespace getVariable [QGVAR(bcs_datalinkUnit), objNull] != ACE_player}) then {
    private _start = [] call FUNC(bcsInit);
    if (_start != "settings") then {
        _page = _start;
        _vehicle setVariable [QGVAR(page), _page];
    };
};
private _missions = GVAR(bcs_missions);
private _missionPages = ["newMission", "engageMission", "solutionMission", "adjustMission"];
// a mission page without its mission: the location stores, as the classic BCS does
if (_page in _missionPages && {GVAR(bcs_mission_index) < 0 || {GVAR(bcs_mission_index) >= count _missions}}) then {
    _page = "locStores";
    _vehicle setVariable [QGVAR(page), _page];
};
private _batteryType = GVAR(bcs_bty_type) # 1;
private _batteryTypeName = getText (configFile >> "itc_land_ballistics" >> "batteryTypes" >> _batteryType >> "displayName");
private _milSystem = [_batteryType] call EFUNC(common,getMilSystem);

// the checks and units of the input fields
private _grid = ["grid"] call FUNC(webCheck);
private _metres = ["number", "m"] call FUNC(webCheck);
private _mils = ["mils", "mil"] call FUNC(webCheck);
private _degrees = ["positive", "deg"] call FUNC(webCheck);
private _whole = ["whole"] call FUNC(webCheck);

// the fire missions, SHOT / SPLASH while counting down
private _missionRows = _missions apply {
    private _shotEnd = _x # 6;
    if (_shotEnd > time) then {
        private _splash = time > _shotEnd - GVAR(bcs_splash_time);
        [_x # 0, createHashMapFromArray [["text", [LLSTRING(Bcs_Shot), LLSTRING(Bcs_Splash)] select _splash], ["c", ["warn", "bad"] select _splash]]]
    } else {
        [_x # 0, ""]
    };
};

private _view = createHashMapFromArray [
    ["header1", "AIFMS"],
    ["header2", LLSTRING(Bcs_FdcSuite)],
    ["side", [
        [LLSTRING(Bcs_SettingsButton), "page", [], LLSTRING(Bcs_Settings), "settings", _page == "settings"] call FUNC(webButton),
        [LLSTRING(Bcs_BatterySetupButton), "page", [], LLSTRING(Bcs_BatterySetup), "setup", _page == "setup"] call FUNC(webButton),
        [LLSTRING(Bcs_LocationStores), "page", [], LLSTRING(WebKnownPoints), "locStores", _page == "locStores"] call FUNC(webButton)
    ]],
    ["sideList", createHashMapFromArray [
        ["title", LLSTRING(WebFireMissions)],
        ["button", [LLSTRING(WebNewMission), "bcsNewMission", [], LLSTRING(Bcs_NewFiremission)] call FUNC(webButton)],
        ["id", "sideMission"],
        ["rows", _missionRows],
        ["selected", [-1, GVAR(bcs_mission_index)] select (_page in _missionPages)],
        ["a", "bcsMission"]
    ]],
    ["status", [
        format [LLSTRING(WebStatusId), ACE_player getVariable [QEGVAR(datalink,id), "-"]],
        format ["%1 (%2)", [GVAR(bcs_bty_name), "-"] select (GVAR(bcs_bty_name) == ""), _batteryTypeName],
        [dayTime, "HH:MM"] call BIS_fnc_timeToString
    ]],
    ["blocks", []]
];

switch (_page) do {
    case "settings": {
        ["bcs/settings", {createHashMapFromArray [
            ["splash", str GVAR(bcs_splash_time)],
            ["code", GVAR(bcs_mission_code)],
            ["start", str GVAR(bcs_mission_start)]
        ]}] call FUNC(webForm);
        private _save = [LLSTRING(bcs_settings_save_button_Text), "bcsSettingsSave", ["splash", "code", "start"], "", nil, false, "primary"] call FUNC(webButton);
        _view set ["title", LLSTRING(Bcs_Settings)];
        _view set ["blocks", [
            ["fields", [["items", [
                ["splash", LLSTRING(bcs_settings_alerttosplash_label_Text), LLSTRING(bcs_settings_alerttosplash_Tooltip), [], "", [],
                    ["positive", "s"] call FUNC(webCheck)] call FUNC(webField),
                ["code", LLSTRING(bcs_settings_firemission_code_label_Text), LLSTRING(bcs_settings_firemission_code_Tooltip), [], "", [], createHashMapFromArray [["max", 4]]] call FUNC(webField),
                ["start", LLSTRING(WebNextMissionNumber), LLSTRING(bcs_settings_firemission_start_Tooltip), [], "", [], _whole] call FUNC(webField)
            ]], ["enter", _save]]] call FUNC(webBlock),
            ["bar", [["left", [_save]]]] call FUNC(webBlock)
        ]];
    };
    case "setup": {
        private _types = (configFile >> "itc_land_ballistics" >> "batteryTypes") call BIS_fnc_getCfgSubClasses;
        GVAR(web) set ["batteryTypes", _types];
        ["bcs/setup", {createHashMapFromArray [
            ["callsign", GVAR(bcs_bty_name)],
            ["type", (_types find _batteryType) max 0],
            ["num", ["gun"] call FUNC(bcsNextId)], ["grid", ""], ["elev", ""], ["dir", ""],
            ["gun", -1], ["link", 0]
        ]}] call FUNC(webForm);

        // guns to link: alive ITC guns of the active battery type on the datalink, friendly, not linked yet, nearest first
        private _linked = GVAR(bcs_bty_guns) apply {_x param [6, objNull]};
        private _friendly = side group ACE_player;
        private _linkable = vehicles select {
            alive _x
            && {!(_x in _linked)}
            && {_x getVariable [QEGVAR(datalink,id), ""] != ""}
            && {[_x] call EFUNC(bcs,getGunBatteryType) == _batteryType}
            && {
                private _side = if (crew _x isEqualTo []) then {(getNumber (configOf _x >> "side")) call BIS_fnc_sideType} else {side _x};
                _friendly getFriend _side >= 0.6
            }
        };
        _linkable = [_linkable, [], {_x distance ACE_player}] call BIS_fnc_sortBy;
        GVAR(web) set ["linkable", _linkable];
        private _linkNames = _linkable apply {
            format ["%1  %2  %3", _x getVariable [QEGVAR(datalink,id), ""], getText (configOf _x >> "displayName"), [getPosASL _x] call EFUNC(common,posToGrid)]
        };

        private _gunRows = GVAR(bcs_bty_guns) apply {
            private _gunVehicle = _x param [6, objNull];
            private _link = if (count _x < 7) then {""} else {
                if (alive _gunVehicle) then {_gunVehicle getVariable [QEGVAR(datalink,id), ""]} else {createHashMapFromArray [["text", LLSTRING(Bcs_GunLost)], ["c", "bad"]]}
            };
            [_x # 0, _x # 1, round (_x # 3), round (_x # 4), _link]
        };
        private _saveBattery = [LLSTRING(WebSaveBattery), "bcsSetupSave", ["callsign", "type"], LLSTRING(btysetup_gun_type_Tooltip), nil, false, "primary"] call FUNC(webButton);
        private _saveGun = [LLSTRING(btysetup_addnew_button_Text), "bcsSetupAddGun", ["num", "grid", "elev", "dir"], LLSTRING(btysetup_gun_number_Tooltip), nil, false, "primary"] call FUNC(webButton);
        private _link = [LLSTRING(btysetup_link_button_Text), "bcsSetupLink", ["link"], LLSTRING(btysetup_link_Tooltip), nil, false, "primary", _linkNames isEqualTo []] call FUNC(webButton);
        _view set ["title", LLSTRING(Bcs_BatterySetup)];
        _view set ["blocks", [
            ["row", [["blocks", [
                ["col", [["blocks", [
                    ["section", [["text", LLSTRING(WebBattery)]]] call FUNC(webBlock),
                    ["fields", [["items", [
                        ["callsign", LLSTRING(btysetup_bty_callsign_label_Text)] call FUNC(webField),
                        ["type", LLSTRING(btysetup_gun_type_label_Text), LLSTRING(btysetup_gun_type_Tooltip),
                            _types apply {getText (configFile >> "itc_land_ballistics" >> "batteryTypes" >> _x >> "displayName")}] call FUNC(webField)
                    ]], ["enter", _saveBattery]]] call FUNC(webBlock),
                    ["kv", [["rows", [[format [LLSTRING(Bcs_ActiveType), _batteryTypeName], ""]]]]] call FUNC(webBlock),
                    ["bar", [["left", [_saveBattery]]]] call FUNC(webBlock),
                    ["section", [["text", LLSTRING(WebLinkGun)], ["tip", LLSTRING(btysetup_link_Tooltip)]]] call FUNC(webBlock),
                    ["fields", [["items", [
                        ["link", LLSTRING(btysetup_link_label_Text), LLSTRING(btysetup_link_Tooltip), [_linkNames, [LLSTRING(Bcs_NoGunsToLink)]] select (_linkNames isEqualTo [])] call FUNC(webField)
                    ]], ["wide", true]]] call FUNC(webBlock),
                    ["bar", [["left", [_link]]]] call FUNC(webBlock)
                ]]]] call FUNC(webBlock),
                ["col", [["blocks", [
                    ["section", [["text", LLSTRING(WebGuns)]]] call FUNC(webBlock),
                    ["list", [["id", "gun"], ["header", ["GUN", "GRID", "ALT", "DIR", "LINK"]], ["rows", _gunRows], ["empty", LLSTRING(WebNoGuns)]]] call FUNC(webBlock),
                    ["bar", [["left", [[LLSTRING(locstores_remove_button_Text), "bcsSetupRemoveGun", ["gun"], "", nil, false, "danger"] call FUNC(webButton)]]]] call FUNC(webBlock),
                    ["section", [["text", LLSTRING(WebAddGun)]]] call FUNC(webBlock),
                    ["fields", [["items", [
                        ["num", LLSTRING(btysetup_gun_number_label_Text), LLSTRING(btysetup_gun_number_Tooltip), [], "", [], _whole] call FUNC(webField),
                        ["grid", LLSTRING(locstores_position_label_Text), LLSTRING(Grid_Tooltip), [], "", [], _grid] call FUNC(webField),
                        ["elev", LLSTRING(locstores_elevation_label_Text), LLSTRING(Altitude_Tooltip), [], "", [], _metres] call FUNC(webField),
                        ["dir", LLSTRING(engagement_direction_text_Text), LLSTRING(btysetup_direction_Tooltip), [], "", [], _degrees] call FUNC(webField)
                    ]], ["enter", _saveGun]]] call FUNC(webBlock),
                    ["bar", [["left", [_saveGun]]]] call FUNC(webBlock)
                ]]]] call FUNC(webBlock)
            ]]]] call FUNC(webBlock)
        ]];
    };
    case "locStores": {
        ["bcs/locStores", {createHashMapFromArray [
            ["id", ["point"] call FUNC(bcsNextId)], ["grid", ""], ["elev", ""], ["friendly", 0], ["loc", -1]
        ]}] call FUNC(webForm);
        private _add = [LLSTRING(locstores_addnew_button_Text), "bcsLocAdd", ["id", "grid", "elev", "friendly"], LLSTRING(locstores_referenceID_Tooltip), nil, false, "primary"] call FUNC(webButton);
        _view set ["title", LLSTRING(WebKnownPoints)];
        _view set ["blocks", [
            ["row", [["blocks", [
                ["col", [["blocks", [
                    ["section", [["text", LLSTRING(WebKnownPoints)]]] call FUNC(webBlock),
                    ["list", [["id", "loc"], ["header", ["ID", "GRID", "ALT", "FRIENDLY"]],
                        ["rows", GVAR(bcs_locations) apply {[_x # 0, _x # 1, _x # 3, ["", "X"] select ((_x # 4) in [true, "yes"])]}],
                        ["empty", LLSTRING(WebNoPoints)]]] call FUNC(webBlock),
                    ["bar", [["left", [[LLSTRING(locstores_remove_button_Text), "bcsLocRemove", ["loc"], "", nil, false, "danger"] call FUNC(webButton)]]]] call FUNC(webBlock)
                ]]]] call FUNC(webBlock),
                ["col", [["blocks", [
                    ["section", [["text", LLSTRING(WebAddPoint)]]] call FUNC(webBlock),
                    ["fields", [["items", [
                        ["id", LLSTRING(locstores_referenceID_label_Text), LLSTRING(locstores_referenceID_Tooltip), [], "", [], createHashMapFromArray [["max", 12]]] call FUNC(webField),
                        ["grid", LLSTRING(locstores_position_label_Text), LLSTRING(Grid_Tooltip), [], "", [], _grid] call FUNC(webField),
                        ["elev", LLSTRING(locstores_elevation_label_Text), LLSTRING(Altitude_Tooltip), [], "", [], _metres] call FUNC(webField),
                        ["friendly", LLSTRING(locstores_isFriendly_label_Text), LLSTRING(locstores_isFriendly_Tooltip), [], "", [], createHashMapFromArray [["kind", "check"]]] call FUNC(webField)
                    ]], ["enter", _add]]] call FUNC(webBlock),
                    ["bar", [["left", [_add]]]] call FUNC(webBlock)
                ]]]] call FUNC(webBlock)
            ]]]] call FUNC(webBlock)
        ]];
    };
    case "newMission": {
        private _mission = _missions # GVAR(bcs_mission_index);
        _mission params ["_ident", "", "_targetPage"];
        _targetPage params ["_targetTypeIndex", "_kpi", "_in0", "_in1", "_in2", "_in3"];
        private _form = ["bcs/newMission/" + _ident, {createHashMapFromArray [
            ["name", _ident], ["type", _targetTypeIndex], ["kp", _kpi],
            ["in0", _in0], ["in1", _in1], ["in2", _in2], ["in3", _in3]
        ]}] call FUNC(webForm);

        // the fields of the target type, as the classic page shows them: label, tooltip, checks and unit
        private _type = _form get "type";
        ([
            [[LLSTRING(Bcs_Grid), LLSTRING(Grid_Tooltip), _grid], [LLSTRING(Bcs_Elevation), LLSTRING(Altitude_Tooltip), _metres]],
            [["OT", LLSTRING(target_field1_text_Tooltip), _mils], ["AD", LLSTRING(target_field2_text_Tooltip), _metres], ["LR", LLSTRING(target_field3_text_Tooltip), _metres], ["UD", LLSTRING(target_field4_text_Tooltip), _metres]],
            [[LLSTRING(Bcs_Direction), LLSTRING(target_polar_direction_Tooltip), _mils], [LLSTRING(Bcs_Distance), LLSTRING(target_polar_distance_Tooltip), _metres], ["VI", LLSTRING(target_vi_Tooltip), _metres]],
            [[LLSTRING(Bcs_Direction), LLSTRING(target_quicklay_direction_Tooltip), _mils], [LLSTRING(Bcs_Distance), LLSTRING(target_quicklay_distance_Tooltip), _metres], ["VI", LLSTRING(target_vi_Tooltip), _metres]]
        ] param [_type, []]) params [["_f0", ["", "", createHashMap]], ["_f1", ["", "", createHashMap]], ["_f2", []], ["_f3", []]];
        private _allFields = ["name", "type", "kp", "in0", "in1", "in2", "in3"];
        private _fields = [
            ["name", LLSTRING(firemission_name_text_Text), LLSTRING(firemission_name_Tooltip), [], "", [], createHashMapFromArray [["max", 12]]] call FUNC(webField),
            ["type", LLSTRING(target_targetType_text_Text), LLSTRING(target_targetType_Tooltip), ["Grid", "Shift", "Polar", "QuickLay"], "bcsNmType", _allFields] call FUNC(webField)
        ];
        if (_type in [0, 1, 2]) then {
            private _points = GVAR(bcs_locations) apply {_x # 0};
            private _extras = createHashMap;
            // Grid: LOAD copies the known point's grid and elevation, beside it
            if (_type == 0) then {
                _extras set ["button", [LLSTRING(target_knownpoint_load_Text), "bcsNmLoad", ["kp"], LLSTRING(target_knownpoint_Tooltip), nil, false, "", _points isEqualTo []] call FUNC(webButton)];
            };
            _fields pushBack (["kp", LLSTRING(target_knownpoint_text_Text), LLSTRING(target_knownpoint_Tooltip), [_points, ["-"]] select (_points isEqualTo []), "", [], _extras] call FUNC(webField));
        };
        {
            _x params ["_id", "_spec"];
            if (_spec isNotEqualTo []) then {
                _spec params ["_label", "_tip", "_extras"];
                _fields pushBack ([_id, _label, _tip, [], "", [], _extras] call FUNC(webField));
            };
        } forEach [["in0", _f0], ["in1", _f1], ["in2", _f2], ["in3", _f3]];

        private _next = [LLSTRING(firemission_next_Text), "bcsNmSave", _allFields, "", nil, false, "primary"] call FUNC(webButton);
        _view set ["title", _ident];
        _view set ["blocks", [
            ["fields", [["items", _fields], ["enter", _next]]] call FUNC(webBlock),
            ["bar", [["groups", [[_next]]]]] call FUNC(webBlock)
        ]];
    };
    case "engageMission": {
        private _mission = _missions # GVAR(bcs_mission_index);
        _mission params ["_ident", "", "", "_engagePage"];
        _engagePage params ["_sheafTypeIndex", "_quick", "_sheafdir", "_sheaflength", "_shellTypeIndex", ["_magazineType", ""], ["_roundCount", 1], ["_fuzeMode", ""]];
        // the active battery type's ammunition, by name
        private _shellTypes = getArray (configFile >> "itc_land_ballistics" >> "batteryTypes" >> _batteryType >> "ammunition");
        GVAR(web) set ["shellTypes", _shellTypes];
        // a round's fuze modes ("modes") or their names ("modeDesc")
        private _fuzeOf = {
            params ["_shell", "_entry"];
            getArray (([_shell] call EFUNC(common,getFuzeConfig)) >> _entry)
        };
        private _form = ["bcs/engageMission/" + _ident, {createHashMapFromArray [
            ["ammo", _shellTypeIndex max 0],
            ["fuze", (([_shellTypes param [_shellTypeIndex max 0, ""], "modes"] call _fuzeOf) find _fuzeMode) max 0],
            ["count", str _roundCount],
            ["sheaf", _sheafTypeIndex],
            // Quick Sheaf as a checkbox: the classic list's first entry, On, is checked
            ["quick", parseNumber (_quick == 0)],
            ["dir", [_sheafdir, _milSystem] call EFUNC(common,formatMils)],
            ["length", str _sheaflength]
        ]}] call FUNC(webForm);
        private _shell = _shellTypes param [_form get "ammo", ""];
        private _allFields = ["ammo", "fuze", "count", "sheaf", "quick", "dir", "length"];
        private _fields = [
            ["ammo", LLSTRING(engage_ammoType_text_Text), "", _shellTypes apply {getText (configFile >> "CfgMagazines" >> _x >> "displayName")}, "bcsEngAmmo", _allFields] call FUNC(webField),
            ["fuze", LLSTRING(engage_fuze_text_Text), LLSTRING(engage_fuze_Tooltip), [[_shell, "modeDesc"] call _fuzeOf, ["-"]] select (_shell == "")] call FUNC(webField),
            ["count", LLSTRING(engage_count_text_Text), LLSTRING(engage_count_Tooltip), [], "", [], ["whole", LLSTRING(WebRoundsPerGun)] call FUNC(webCheck)] call FUNC(webField),
            ["sheaf", LLSTRING(engagement_sheaf_text_Text), LLSTRING(engagement_sheaf_Tooltip), ["Parallel", "Converged", "Linear", "Open", "Special"], "bcsEngSheaf", _allFields] call FUNC(webField)
        ];
        // a special sheaf only: its direction (or quick, at right angles to the gun-target line) and width
        if ((_form get "sheaf") == 4) then {
            _fields append [
                ["quick", LLSTRING(engagement_quick_text_Text), LLSTRING(engagement_quick_Tooltip), [], "bcsEngSheaf", _allFields, createHashMapFromArray [["kind", "check"]]] call FUNC(webField),
                ["dir", LLSTRING(engagement_direction_text_Text), LLSTRING(engagement_direction_Tooltip), [], "", [], _mils] call FUNC(webField),
                ["length", LLSTRING(engagement_length_text_Text), LLSTRING(engagement_length_Tooltip), [], "", [], _metres] call FUNC(webField)
            ];
        };
        private _next = [LLSTRING(firemission_next_Text), "bcsEngSave", _allFields, "", nil, false, "primary"] call FUNC(webButton);
        _view set ["title", format [LLSTRING(Bcs_Engagement), _ident]];
        _view set ["blocks", [
            ["fields", [["items", _fields], ["enter", _next]]] call FUNC(webBlock),
            ["bar", [["left", [[LLSTRING(firemission_back_Text), "bcsEngBack"] call FUNC(webButton)]], ["groups", [[_next]]]]] call FUNC(webBlock)
        ]];
    };
    case "solutionMission": {
        private _mission = _missions # GVAR(bcs_mission_index);
        _mission params ["_ident", "", "_targetPage", "_engagePage", "_curSolution", "", "_shotEnd"];
        private _form = ["bcs/solutionMission/" + _ident, {createHashMapFromArray [["gun", 0]]}] call FUNC(webForm);
        _view set ["title", format [LLSTRING(Bcs_Solutions), _ident]];
        _view set ["tti", ["", format [LLSTRING(Bcs_TimeToImpact), round (_shotEnd - time)]] select (_shotEnd > time)];

        // the classic solution page's calculation, again only when its inputs changed; linked guns where their vehicles are now
        private _tgtPos = _targetPage param [6, []];
        private _guns = [GVAR(bcs_bty_guns)] call EFUNC(bcs,refreshLinkedGuns);
        private _key = [_ident, _tgtPos, _engagePage, _guns apply {[_x # 0, _x # 2, _x # 4]}, _batteryType];
        if (_key isNotEqualTo (GVAR(web) get "solutionKey")) then {
            GVAR(web) set ["solutionKey", _key];
            GVAR(web) set ["solutions", [_guns, _engagePage param [5, ""], _tgtPos, _engagePage, _batteryType] call EFUNC(bcs,calcSolutions)];
        };
        (GVAR(web) get "solutions") params ["_btySolutions", "_gunSolutions"];
        _mission set [5, (count _btySolutions) - 1];
        private _index = _curSolution min (count _btySolutions - 1) max 0;
        private _adjGun = (_form get "gun") min (count _gunSolutions - 1) max 0;

        private _summary = if (_btySolutions isEqualTo []) then {
            [[LLSTRING(Bcs_NoSolutions), "", "bad"], [LLSTRING(solution_distance_label_Text), if (_guns isEqualTo [] || {!(_tgtPos isEqualTypeArray [0, 0, 0])}) then {"-"} else {round (([_guns] call EFUNC(bcs,getBatteryPosition)) distance _tgtPos)}, "", LLSTRING(solution_distance_Tooltip)]]
        } else {
            (_btySolutions # _index) params ["", "", "", "", "_tof", "", "_impAng", "_maxOrd", "_dist"];
            [
                // the message to the observer: who fires, how many rounds, on which target, how long the rounds fly
                [LLSTRING(WebMtoLabel), format [LLSTRING(WebMto), [GVAR(bcs_bty_name), LLSTRING(WebBattery)] select (GVAR(bcs_bty_name) == ""), _engagePage param [6, 1], _ident, round _tof], "ok", LLSTRING(WebMtoTip)],
                [LLSTRING(solution_ordinate_label_Text), format ["%1 m", round _maxOrd], "", LLSTRING(solution_ordinate_Tooltip)],
                [LLSTRING(solution_angle_label_Text), format ["%1 deg", round _impAng], "", LLSTRING(solution_angle_Tooltip)],
                [LLSTRING(solution_distance_label_Text), format ["%1 m", round _dist], "", LLSTRING(solution_distance_Tooltip)]
            ]
        };
        // the fire command order: charge, fuze setting, deflection, quadrant; azimuth and time of flight after
        private _lines = [];
        {
            _x params ["_num", "_gunSolutionList"];
            private _line = if (_btySolutions isEqualTo []) then {[]} else {[_gunSolutionList, _btySolutions # _index] call EFUNC(bcs,matchGunSolution)};
            private _gunVehicle = (_guns param [_guns findIf {_x # 0 == _num}, []]) param [6, objNull];
            private _status = ["", [_gunVehicle] call EFUNC(common,getGunStatusText)] select (alive _gunVehicle && {isNumber (configOf _gunVehicle >> "itc_land" >> "loaderType")});
            private _marker = ["", createHashMapFromArray [["text", "ADJ"], ["c", "ok"]]] select (_forEachIndex == _adjGun);
            _lines pushBack (if (_line isEqualTo []) then {
                [_marker, _num, createHashMapFromArray [["text", LLSTRING(Fcs_NoSolution)], ["c", "bad"]], "", "", "", "", "", _status]
            } else {
                private _fuzeSetting = _line param [10, -1];
                [
                    _marker, _num, _line # 0,
                    ["", [_fuzeSetting, 1, 1] call CBA_fnc_formatNumber] select (_fuzeSetting >= 0),
                    [parseNumber (_line # 2), _milSystem] call EFUNC(common,formatMils),
                    [_line # 3, _milSystem] call EFUNC(common,formatMils),
                    [_line # 1, _milSystem] call EFUNC(common,formatMils),
                    [_line # 4, 1, 2] call CBA_fnc_formatNumber,
                    _status
                ]
            });
        } forEach _gunSolutions;
        private _adjNum = (_gunSolutions param [_adjGun, ["-"]]) # 0;
        private _blocks = [];
        if (_btySolutions isNotEqualTo []) then {
            _blocks pushBack (["stepper", [
                ["label", LLSTRING(WebSolution)],
                ["value", format ["%1 / %2", _index + 1, count _btySolutions]],
                ["a", "bcsSolStep"],
                ["tip", LLSTRING(solution_solutionCount_Tooltip)]
            ]] call FUNC(webBlock));
        };
        _blocks append [
            ["kv", [["rows", _summary]]] call FUNC(webBlock),
            ["list", [["id", "gun"], ["a", "bcsAdjGun"], ["selected", _adjGun],
                ["header", ["", "G", "CH", "FS", "DF", "QD", "AZ", "TOF", ""]],
                ["tips", [LLSTRING(WebAdjustingGunTip), LLSTRING(WebTip_Gun), LLSTRING(WebTip_Charge), LLSTRING(WebTip_FuzeSetting), LLSTRING(WebTip_Deflection),
                    LLSTRING(WebTip_Quadrant), LLSTRING(WebTip_Azimuth), LLSTRING(WebTip_TimeOfFlight), LLSTRING(WebTip_Loader)]],
                ["rows", _lines], ["empty", LLSTRING(WebNoGuns)]]] call FUNC(webBlock),
            ["bar", [
                ["left", [[LLSTRING(firemission_back_Text), "bcsSolBack"] call FUNC(webButton)]],
                ["groups", [
                    [
                        [LLSTRING(solution_shot_Text), "bcsShot", [], LLSTRING(solution_shot_Tooltip)] call FUNC(webButton),
                        [format [LLSTRING(WebSendAdjGun), _adjNum], "bcsSendAdj", [], LLSTRING(solution_send_adj_Tooltip)] call FUNC(webButton),
                        [LLSTRING(solution_send_ffe_Text), "bcsSendFfe", [], LLSTRING(solution_send_ffe_Tooltip), nil, false, "primary"] call FUNC(webButton)
                    ],
                    [[LLSTRING(WebAdjust), "bcsAdjust", [], LLSTRING(Bcs_AdjustMission)] call FUNC(webButton)]
                ]]
            ]] call FUNC(webBlock),
            ["bar", [["groups", [[
                [LLSTRING(solution_eom_Text), "bcsEom", [], "", nil, false, "danger"] call FUNC(webButton),
                [LLSTRING(WebEomRecord), "bcsEomSave", [], "", nil, false, "danger"] call FUNC(webButton)
            ]]]]] call FUNC(webBlock)
        ];
        _view set ["blocks", _blocks];
    };
    case "adjustMission": {
        private _ident = (_missions # GVAR(bcs_mission_index)) # 0;
        // the observer-target direction stays for the whole mission: the last one is filled in
        private _lastOt = (missionNamespace getVariable [QGVAR(bcs_lastOT), createHashMap]) getOrDefault [_ident, "0"];
        ["bcs/adjustMission/" + _ident, {createHashMapFromArray [["ot", _lastOt], ["ad", "0"], ["lr", "0"], ["ud", "0"]]}] call FUNC(webForm);
        private _apply = [LLSTRING(WebApplyCorrection), "bcsAdjSave", ["ot", "ad", "lr", "ud"], "", nil, false, "primary"] call FUNC(webButton);
        _view set ["title", format ["%1 - %2", LLSTRING(Bcs_AdjustMission), _ident]];
        _view set ["blocks", [
            ["fields", [["items", [
                ["ot", LLSTRING(target_field1_text_Text), LLSTRING(target_field1_text_Tooltip), [], "", [], _mils] call FUNC(webField),
                ["ad", LLSTRING(target_field2_text_Text), LLSTRING(target_field2_text_Tooltip), [], "", [], _metres] call FUNC(webField),
                ["lr", LLSTRING(target_field3_text_Text), LLSTRING(target_field3_text_Tooltip), [], "", [], _metres] call FUNC(webField),
                ["ud", LLSTRING(target_field4_text_Text), LLSTRING(target_field4_text_Tooltip), [], "", [], _metres] call FUNC(webField)
            ]], ["enter", _apply]]] call FUNC(webBlock),
            ["bar", [["left", [[LLSTRING(firemission_back_Text), "bcsAdjBack"] call FUNC(webButton)]], ["groups", [[_apply]]]]] call FUNC(webBlock)
        ]];
    };
};
_view
