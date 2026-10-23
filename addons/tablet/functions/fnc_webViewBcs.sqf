#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's BCS, page by page as the classic one (the same data, the actions in
 * tablet_fnc_webActionBcs): settings, battery setup (guns by hand or linked over the datalink),
 * location stores, and a fire mission's target, engagement, solutions (with each gun's line and
 * loader status, SHOT, SEND ADJ / FFE, end of mission) and adjustment. The sidebar has the pages
 * and the fire missions with SHOT / SPLASH.
 *
 * Arguments:
 * 0: Vehicle (the tablet's page is kept on it) <OBJECT>
 *
 * Return Value:
 * View <HASHMAP>
 *
 * Example:
 * [player] call itc_land_tablet_fnc_webViewBcs
 *
 * Public: No
 */

params ["_vehicle"];

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
private _milSystem = [_batteryType] call EFUNC(common,getMilSystem);

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
        [LLSTRING(Bcs_SettingsButton), "page", [], "", "settings", _page == "settings"] call FUNC(webButton),
        [LLSTRING(Bcs_BatterySetupButton), "page", [], "", "setup", _page == "setup"] call FUNC(webButton),
        [LLSTRING(Bcs_LocationStores), "page", [], "", "locStores", _page == "locStores"] call FUNC(webButton),
        [LLSTRING(Bcs_NewFiremission), "bcsNewMission"] call FUNC(webButton)
    ]],
    ["sideList", createHashMapFromArray [
        ["id", "sideMission"],
        ["rows", _missionRows],
        ["selected", [-1, GVAR(bcs_mission_index)] select (_page in _missionPages)],
        ["a", "bcsMission"]
    ]],
    ["blocks", []]
];

private _block = {
    params ["_type", ["_pairs", []]];
    private _map = createHashMapFromArray _pairs;
    _map set ["t", _type];
    _map
};

switch (_page) do {
    case "settings": {
        ["bcs/settings", {createHashMapFromArray [
            ["splash", str GVAR(bcs_splash_time)],
            ["code", GVAR(bcs_mission_code)],
            ["start", str GVAR(bcs_mission_start)]
        ]}] call FUNC(webForm);
        private _save = [LLSTRING(bcs_settings_save_button_Text), "bcsSettingsSave", ["splash", "code", "start"]] call FUNC(webButton);
        _view set ["title", LLSTRING(Bcs_Settings)];
        _view set ["blocks", [
            ["fields", [["items", [
                ["splash", LLSTRING(bcs_settings_alerttosplash_label_Text), LLSTRING(bcs_settings_alerttosplash_Tooltip)] call FUNC(webField),
                ["code", LLSTRING(bcs_settings_firemission_code_label_Text), LLSTRING(bcs_settings_firemission_code_Tooltip)] call FUNC(webField),
                ["start", LLSTRING(bcs_settings_firemission_start_label_Text), LLSTRING(bcs_settings_firemission_start_Tooltip)] call FUNC(webField)
            ]], ["enter", _save]]] call _block,
            ["buttons", [["items", [_save]]]] call _block
        ]];
    };
    case "setup": {
        private _types = (configFile >> "itc_land_ballistics" >> "batteryTypes") call BIS_fnc_getCfgSubClasses;
        GVAR(web) set ["batteryTypes", _types];
        ["bcs/setup", {createHashMapFromArray [
            ["callsign", GVAR(bcs_bty_name)],
            ["type", (_types find _batteryType) max 0],
            ["num", [] call FUNC(bcsNextGunNumber)], ["grid", ""], ["elev", ""], ["dir", ""],
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
            private _vehicle = _x param [6, objNull];
            private _link = if (count _x < 7) then {""} else {
                if (alive _vehicle) then {_vehicle getVariable [QEGVAR(datalink,id), ""]} else {createHashMapFromArray [["text", LLSTRING(Bcs_GunLost)], ["c", "bad"]]}
            };
            [_x param [5, GVAR(bcs_bty_name)], _x # 0, _x # 1, round (_x # 3), round (_x # 4), _link]
        };
        private _addGun = [LLSTRING(btysetup_addnew_button_Text), "bcsSetupAddGun", ["num", "grid", "elev", "dir"]] call FUNC(webButton);
        _view set ["title", LLSTRING(Bcs_BatterySetup)];
        _view set ["blocks", [
            ["row", [["blocks", [
                ["fields", [["items", [
                    ["callsign", LLSTRING(btysetup_bty_callsign_label_Text)] call FUNC(webField),
                    ["type", LLSTRING(btysetup_gun_type_label_Text), LLSTRING(btysetup_gun_type_Tooltip),
                        _types apply {getText (configFile >> "itc_land_ballistics" >> "batteryTypes" >> _x >> "displayName")}] call FUNC(webField)
                ]]]] call _block,
                ["kv", [["rows", [[format [LLSTRING(Bcs_ActiveType), getText (configFile >> "itc_land_ballistics" >> "batteryTypes" >> _batteryType >> "displayName")], ""]]]]] call _block
            ]]]] call _block,
            ["buttons", [["items", [[LLSTRING(btysetup_save_button_Text), "bcsSetupSave", ["callsign", "type"], LLSTRING(btysetup_gun_type_Tooltip)] call FUNC(webButton)]]]] call _block,
            ["fields", [["items", [
                ["num", LLSTRING(btysetup_gun_number_label_Text), LLSTRING(btysetup_gun_number_Tooltip)] call FUNC(webField),
                ["grid", LLSTRING(locstores_position_label_Text), LLSTRING(Grid_Tooltip)] call FUNC(webField),
                ["elev", LLSTRING(locstores_elevation_label_Text), LLSTRING(Altitude_Tooltip)] call FUNC(webField),
                ["dir", LLSTRING(engagement_direction_text_Text), LLSTRING(btysetup_direction_Tooltip)] call FUNC(webField)
            ]], ["enter", _addGun]]] call _block,
            ["buttons", [["items", [
                _addGun,
                [LLSTRING(locstores_remove_button_Text), "bcsSetupRemoveGun", ["gun"]] call FUNC(webButton)
            ]]]] call _block,
            ["list", [["id", "gun"], ["header", ["BTY", "GUN", "GRID", "ALT", "DIR", "LINK"]], ["rows", _gunRows]]] call _block,
            ["fields", [["items", [
                ["link", LLSTRING(btysetup_link_label_Text), LLSTRING(btysetup_link_Tooltip), [_linkNames, [LLSTRING(Bcs_NoGunsToLink)]] select (_linkNames isEqualTo [])] call FUNC(webField)
            ]], ["wide", true]]] call _block,
            ["buttons", [["items", [[LLSTRING(btysetup_link_button_Text), "bcsSetupLink", ["link"], LLSTRING(btysetup_link_Tooltip)] call FUNC(webButton)]]]] call _block
        ]];
    };
    case "locStores": {
        ["bcs/locStores", {createHashMapFromArray [
            ["id", "AB0001"], ["grid", ""], ["elev", ""], ["friendly", 0], ["loc", -1]
        ]}] call FUNC(webForm);
        private _add = [LLSTRING(locstores_addnew_button_Text), "bcsLocAdd", ["id", "grid", "elev", "friendly"]] call FUNC(webButton);
        _view set ["title", LLSTRING(Bcs_LocationStores)];
        _view set ["blocks", [
            ["fields", [["items", [
                ["id", LLSTRING(locstores_referenceID_label_Text), LLSTRING(locstores_referenceID_Tooltip)] call FUNC(webField),
                ["grid", LLSTRING(locstores_position_label_Text), LLSTRING(Grid_Tooltip)] call FUNC(webField),
                ["elev", LLSTRING(locstores_elevation_label_Text), LLSTRING(Altitude_Tooltip)] call FUNC(webField),
                ["friendly", LLSTRING(locstores_isFriendly_label_Text), LLSTRING(locstores_isFriendly_Tooltip), ["no", "yes"]] call FUNC(webField)
            ]], ["enter", _add]]] call _block,
            ["buttons", [["items", [_add, [LLSTRING(locstores_remove_button_Text), "bcsLocRemove", ["loc"]] call FUNC(webButton)]]]] call _block,
            ["list", [["id", "loc"], ["header", ["ID", "GRID", "ALT", "FRIENDLY"]], ["rows", GVAR(bcs_locations) apply {[_x # 0, _x # 1, _x # 3, str (_x # 4)]}]]] call _block
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

        // the fields of the target type, as the classic page shows them
        private _type = _form get "type";
        ([
            [[LLSTRING(Bcs_Grid), LLSTRING(Grid_Tooltip)], [LLSTRING(Bcs_Elevation), LLSTRING(Altitude_Tooltip)]],
            [["OT", LLSTRING(target_field1_text_Tooltip)], ["AD", LLSTRING(target_field2_text_Tooltip)], ["LR", LLSTRING(target_field3_text_Tooltip)], ["UD", LLSTRING(target_field4_text_Tooltip)]],
            [[LLSTRING(Bcs_Direction), LLSTRING(target_polar_direction_Tooltip)], [LLSTRING(Bcs_Distance), LLSTRING(target_polar_distance_Tooltip)], ["VI", LLSTRING(target_vi_Tooltip)]],
            [[LLSTRING(Bcs_Direction), LLSTRING(target_quicklay_direction_Tooltip)], [LLSTRING(Bcs_Distance), LLSTRING(target_quicklay_distance_Tooltip)], ["VI", LLSTRING(target_vi_Tooltip)]]
        ] param [_type, []]) params [["_f0", ["", ""]], ["_f1", ["", ""]], ["_f2", []], ["_f3", []]];
        private _allFields = ["name", "type", "kp", "in0", "in1", "in2", "in3"];
        private _fields = [
            ["name", LLSTRING(firemission_name_text_Text), LLSTRING(firemission_name_Tooltip)] call FUNC(webField),
            ["type", LLSTRING(target_targetType_text_Text), LLSTRING(target_targetType_Tooltip), ["Grid", "Shift", "Polar", "QuickLay"], "bcsNmType", _allFields] call FUNC(webField)
        ];
        if (_type in [0, 1, 2]) then {
            private _points = GVAR(bcs_locations) apply {_x # 0};
            _fields pushBack (["kp", LLSTRING(target_knownpoint_text_Text), LLSTRING(target_knownpoint_Tooltip), [_points, ["-"]] select (_points isEqualTo [])] call FUNC(webField));
        };
        _fields pushBack (["in0", _f0 # 0, _f0 # 1] call FUNC(webField));
        _fields pushBack (["in1", _f1 # 0, _f1 # 1] call FUNC(webField));
        if (_f2 isNotEqualTo []) then {_fields pushBack (["in2", _f2 # 0, _f2 # 1] call FUNC(webField))};
        if (_f3 isNotEqualTo []) then {_fields pushBack (["in3", _f3 # 0, _f3 # 1] call FUNC(webField))};

        private _next = [LLSTRING(firemission_next_Text), "bcsNmSave", _allFields] call FUNC(webButton);
        private _buttons = [_next];
        if (_type == 0) then {_buttons pushBack ([LLSTRING(target_knownpoint_load_Text), "bcsNmLoad", ["kp"], LLSTRING(target_knownpoint_Tooltip)] call FUNC(webButton))};
        _view set ["title", _ident];
        _view set ["blocks", [
            ["fields", [["items", _fields], ["enter", _next]]] call _block,
            ["buttons", [["items", _buttons]]] call _block
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
            getArray (configFile >> "ITC_Land_CfgFuzes" >> getText (configFile >> "CfgMagazines" >> _shell >> "itc_land_fuze") >> _entry)
        };
        private _form = ["bcs/engageMission/" + _ident, {createHashMapFromArray [
            ["ammo", _shellTypeIndex max 0],
            ["fuze", (([_shellTypes param [_shellTypeIndex max 0, ""], "modes"] call _fuzeOf) find _fuzeMode) max 0],
            ["count", str _roundCount],
            ["sheaf", _sheafTypeIndex],
            ["quick", _quick],
            ["dir", [_sheafdir, _milSystem] call EFUNC(common,formatMils)],
            ["length", str _sheaflength]
        ]}] call FUNC(webForm);
        private _shell = _shellTypes param [_form get "ammo", ""];
        private _allFields = ["ammo", "fuze", "count", "sheaf", "quick", "dir", "length"];
        private _next = [LLSTRING(firemission_next_Text), "bcsEngSave", _allFields] call FUNC(webButton);
        _view set ["title", format [LLSTRING(Bcs_Engagement), _ident]];
        _view set ["blocks", [
            ["fields", [["items", [
                ["ammo", LLSTRING(engage_ammoType_text_Text), "", _shellTypes apply {getText (configFile >> "CfgMagazines" >> _x >> "displayName")}, "bcsEngAmmo", _allFields] call FUNC(webField),
                ["fuze", LLSTRING(engage_fuze_text_Text), LLSTRING(engage_fuze_Tooltip), [[_shell, "modeDesc"] call _fuzeOf, ["-"]] select (_shell == "")] call FUNC(webField),
                ["count", LLSTRING(engage_count_text_Text), LLSTRING(engage_count_Tooltip)] call FUNC(webField),
                ["sheaf", LLSTRING(engagement_sheaf_text_Text), LLSTRING(engagement_sheaf_Tooltip), ["Parallel", "Converged", "Linear", "Open", "Special"]] call FUNC(webField),
                ["quick", LLSTRING(engagement_quick_text_Text), LLSTRING(engagement_quick_Tooltip), ["On", "Off"]] call FUNC(webField),
                ["dir", LLSTRING(engagement_direction_text_Text), LLSTRING(engagement_direction_Tooltip)] call FUNC(webField),
                ["length", LLSTRING(engagement_length_text_Text), LLSTRING(engagement_length_Tooltip)] call FUNC(webField)
            ]], ["enter", _next]]] call _block,
            ["buttons", [["items", [
                [LLSTRING(firemission_back_Text), "bcsEngBack"] call FUNC(webButton),
                _next
            ]]]] call _block
        ]];
    };
    case "solutionMission": {
        private _mission = _missions # GVAR(bcs_mission_index);
        _mission params ["_ident", "", "_targetPage", "_engagePage", "_curSolution", "", "_shotEnd"];
        ["bcs/solutionMission/" + _ident, {createHashMapFromArray [["gun", 0]]}] call FUNC(webForm);
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

        private _summary = if (_btySolutions isEqualTo []) then {
            [[LLSTRING(Bcs_NoSolutions), "", "bad"], [LLSTRING(solution_distance_label_Text), if (_guns isEqualTo [] || {!(_tgtPos isEqualTypeArray [0, 0, 0])}) then {"-"} else {round (([_guns] call EFUNC(bcs,getBatteryPosition)) distance _tgtPos)}, "", LLSTRING(solution_distance_Tooltip)]]
        } else {
            private _index = _curSolution min (count _btySolutions - 1) max 0;
            (_btySolutions # _index) params ["", "", "", "", "", "", "_impAng", "_maxOrd", "_dist"];
            [
                [format [LLSTRING(Bcs_SolutionOf), _index + 1, count _btySolutions], "", "", LLSTRING(solution_solutionCount_Tooltip)],
                [LLSTRING(solution_ordinate_label_Text), round _maxOrd, "", LLSTRING(solution_ordinate_Tooltip)],
                [LLSTRING(solution_angle_label_Text), round _impAng, "", LLSTRING(solution_angle_Tooltip)],
                [LLSTRING(solution_distance_label_Text), round _dist, "", LLSTRING(solution_distance_Tooltip)]
            ]
        };
        private _index = _curSolution min (count _btySolutions - 1) max 0;
        private _lines = _gunSolutions apply {
            _x params ["_num", "_gunSolutionList"];
            private _line = if (_btySolutions isEqualTo []) then {[]} else {[_gunSolutionList, _btySolutions # _index] call EFUNC(bcs,matchGunSolution)};
            private _vehicle = (_guns param [_guns findIf {_x # 0 == _num}, []]) param [6, objNull];
            private _status = ["", [_vehicle] call EFUNC(common,getGunStatusText)] select (alive _vehicle && {isNumber (configOf _vehicle >> "itc_land" >> "loaderType")});
            if (_line isEqualTo []) then {
                [_num, createHashMapFromArray [["text", LLSTRING(Fcs_NoSolution)], ["c", "bad"]], "", "", "", "", "", _status]
            } else {
                private _fuzeSetting = _line param [10, -1];
                [
                    _num, _line # 0,
                    [_line # 1, _milSystem] call EFUNC(common,formatMils),
                    [parseNumber (_line # 2), _milSystem] call EFUNC(common,formatMils),
                    [_line # 3, _milSystem] call EFUNC(common,formatMils),
                    [_line # 4, 1, 2] call CBA_fnc_formatNumber,
                    ["", [_fuzeSetting, 1, 1] call CBA_fnc_formatNumber] select (_fuzeSetting >= 0),
                    _status
                ]
            };
        };
        _view set ["blocks", [
            ["row", [["blocks", [
                ["kv", [["rows", _summary]]] call _block,
                ["buttons", [["items", [
                    [LLSTRING(solution_soldn_Text), "bcsSolDown", [], LLSTRING(solution_solutionCount_Tooltip)] call FUNC(webButton),
                    [LLSTRING(solution_solup_Text), "bcsSolUp", [], LLSTRING(solution_solutionCount_Tooltip)] call FUNC(webButton)
                ]]]] call _block
            ]]]] call _block,
            ["list", [["id", "gun"], ["header", ["G", "CH", "AZ", "DF", "QD", "TOF", "FS", ""]], ["rows", _lines], ["tips", [
                LLSTRING(WebTip_Gun), LLSTRING(WebTip_Charge), LLSTRING(WebTip_Azimuth), LLSTRING(WebTip_Deflection),
                LLSTRING(WebTip_Quadrant), LLSTRING(WebTip_TimeOfFlight), LLSTRING(WebTip_FuzeSetting), LLSTRING(WebTip_Loader)
            ]]]] call _block,
            ["buttons", [["items", [
                [LLSTRING(solution_shot_Text), "bcsShot", [], LLSTRING(solution_shot_Tooltip)] call FUNC(webButton),
                [LLSTRING(solution_send_adj_Text), "bcsSendAdj", ["gun"], LLSTRING(solution_send_adj_Tooltip)] call FUNC(webButton),
                [LLSTRING(solution_send_ffe_Text), "bcsSendFfe", [], LLSTRING(solution_send_ffe_Tooltip)] call FUNC(webButton),
                [LLSTRING(solution_adj_Text), "bcsAdjust"] call FUNC(webButton)
            ]]]] call _block,
            ["buttons", [["items", [
                [LLSTRING(firemission_back_Text), "bcsSolBack"] call FUNC(webButton),
                [LLSTRING(solution_eom_Text), "bcsEom"] call FUNC(webButton),
                [LLSTRING(solution_eom_save_Text), "bcsEomSave"] call FUNC(webButton)
            ]]]] call _block
        ]];
    };
    case "adjustMission": {
        private _ident = (_missions # GVAR(bcs_mission_index)) # 0;
        ["bcs/adjustMission/" + _ident, {createHashMapFromArray [["ot", "0"], ["ad", "0"], ["lr", "0"], ["ud", "0"]]}] call FUNC(webForm);
        private _next = [LLSTRING(firemission_next_Text), "bcsAdjSave", ["ot", "ad", "lr", "ud"]] call FUNC(webButton);
        _view set ["title", LLSTRING(Bcs_AdjustMission)];
        _view set ["blocks", [
            ["fields", [["items", [
                ["ot", LLSTRING(target_field1_text_Text), LLSTRING(target_field1_text_Tooltip)] call FUNC(webField),
                ["ad", LLSTRING(target_field2_text_Text), LLSTRING(target_field2_text_Tooltip)] call FUNC(webField),
                ["lr", LLSTRING(target_field3_text_Text), LLSTRING(target_field3_text_Tooltip)] call FUNC(webField),
                ["ud", LLSTRING(target_field4_text_Text), LLSTRING(target_field4_text_Tooltip)] call FUNC(webField)
            ]], ["enter", _next]]] call _block,
            ["buttons", [["items", [[LLSTRING(firemission_back_Text), "bcsAdjBack"] call FUNC(webButton), _next]]]] call _block
        ]];
    };
};
_view
