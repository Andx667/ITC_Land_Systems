#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's SPG and MLRS apps (the classic "artillery" app with the spg and missile FCI
 * pages): the FCI page computes firing solutions for the vehicle on a target grid (tablet_fnc_
 * webActionArtillery) and shows the selected one, or the FDC's fire data; the MLRS also sets the
 * fuze and guidance of its rockets and fills in the FDC's orders. The status page lists the
 * vehicle's systems and fuel. Without the vehicle's SPG interface the app says so.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: App ("spg" or "missile") <STRING>
 *
 * Return Value:
 * View <HASHMAP>
 *
 * Example:
 * [vehicle player, "spg"] call itc_land_tablet_fnc_webViewArtillery
 *
 * Public: No
 */

params ["_vehicle", "_app"];

private _appConfig = configFile >> "itc_land" >> "apps" >> _app;
private _view = createHashMapFromArray [
    ["header1", LLSTRING(Artillery_Vehicle)],
    ["header2", getText (_appConfig >> "subtitle")],
    ["side", []],
    ["blocks", []]
];

if !("spg" in getArray (configOf _vehicle >> "itc_land" >> "tabletInterfaces")) exitWith {
    [_app + "/none", {createHashMap}] call FUNC(webForm);
    _view set ["header1", getText (_appConfig >> "title")];
    _view set ["header2", LLSTRING(Artillery_NoInterface)];
    _view set ["title", LLSTRING(Artillery_InterfaceNotFound)];
    _view
};

private _page = _vehicle getVariable [QGVAR(page), "fcs"];
_view set ["side", [
    ["FCI", "page", [], "", "fcs", _page == "fcs"] call FUNC(webButton),
    [getText (_appConfig >> "sidebar2"), "page", [], "", "status", _page == "status"] call FUNC(webButton)
]];

if (_page == "status") exitWith {
    [_app + "/status", {createHashMap}] call FUNC(webForm);
    _view set ["title", LLSTRING(Artillery_VehicleStatus)];
    (getAllHitPointsDamage _vehicle) params [["_hitPoints", []], ["_selections", []], ["_damage", []]];
    // ACE Repair names hitpoints like its repair menu (HitGlass3 -> "Glass", numbered when a part repeats)
    private _hitPointTrack = [[], [], []];
    private _rows = [];
    {
        private _hitPoint = _hitPoints select _forEachIndex;
        private _label = [_selections select _forEachIndex, _hitPoint] select (_hitPoint != "");
        if (_hitPoint != "" && {!isNil "ace_repair_fnc_getHitPointString"}) then {
            ([_hitPoint, "%1", _label, _hitPointTrack] call ace_repair_fnc_getHitPointString) params ["_text", "_track"];
            _label = _text;
            _hitPointTrack = _track;
        };
        private _status = switch (true) do {
            case (_x > 0.5): {createHashMapFromArray [["text", LLSTRING(Artillery_StatusFailed)], ["c", "bad"]]};
            case (_x > 0): {createHashMapFromArray [["text", LLSTRING(Artillery_StatusDamaged)], ["c", "warn"]]};
            default {createHashMapFromArray [["text", LLSTRING(Artillery_StatusOk)], ["c", "ok"]]};
        };
        _rows pushBack [_label, _status];
    } forEach _damage;
    _view set ["blocks", [
        createHashMapFromArray [["t", "row"], ["blocks", [
            createHashMapFromArray [["t", "list"], ["header", [LLSTRING(status_dam_title_Text), ""]], ["tips", [LLSTRING(status_dam_list_Tooltip), LLSTRING(status_dam_list_Tooltip)]], ["rows", _rows]],
            createHashMapFromArray [["t", "kv"], ["rows", [[LLSTRING(status_info_fuel_Text), format ["%1%2", round (fuel _vehicle * 100), "%"]]]]]
        ]]]
    ]];
    _view
};

// FCI: the rounds of the battery type of the vehicle's gun; the MLRS only those it carries
private _missile = _app == "missile";
private _weapon = [(_vehicle weaponsTurret [0]) param [0, ""], (weapons _vehicle) param [0, ""]] select _missile;
private _types = format ["getText (_x >> 'weaponClass') == '%1'", _weapon] configClasses (configFile >> "itc_land_ballistics" >> "batteryTypes");
private _rounds = getArray ((_types param [0, configNull]) >> "ammunition");
if (_missile) then {
    private _carried = magazines _vehicle;
    _rounds = _rounds select {_x in _carried};
};
GVAR(web) set ["rounds", _rounds];

private _form = [_app + "/fcs", {
    createHashMapFromArray [
        ["grid", _vehicle getVariable ["itc_land_tablet_fcs_tgtgrid", ""]],
        ["elev", [str (_vehicle getVariable ["itc_land_tablet_fcs_tgtelev", 0]), ""] select isNil {_vehicle getVariable "itc_land_tablet_fcs_tgtelev"}],
        ["round", 0],
        ["fuze", (_vehicle getVariable ["itc_land_selectedFuzeIndex", 0]) max 0],
        ["time", str (_vehicle getVariable ["itc_land_mlrsfci_fuzeTime", 0])],
        ["pgmGrid", format ["%1", _vehicle getVariable ["itc_land_guidance_targetGrid", "0000000000"]]],
        ["pgmAlt", format ["%1", _vehicle getVariable ["itc_land_guidance_targetAlt", 0]]]
    ]
}] call FUNC(webForm);
if ((_form get "round") >= count _rounds) then {_form set ["round", 0]};

private _roundNames = _rounds apply {getText (configFile >> "CfgMagazines" >> _x >> "displayName")};
private _fields = [
    ["grid", LLSTRING(fcs_target_pos_Text), LLSTRING(fcs_target_pos_Tooltip)] call FUNC(webField),
    ["elev", LLSTRING(fcs_target_elev_Text), LLSTRING(fcs_target_elev_Tooltip)] call FUNC(webField),
    ["round", LLSTRING(fcs_round_type_Text2), LLSTRING(fcs_round_type_Tooltip), _roundNames, ["", "artRound"] select _missile] call FUNC(webField)
];
private _calcFields = ["grid", "elev", "round"];
private _blocks = [
    createHashMapFromArray [["t", "section"], ["text", LLSTRING(fcs_target_title_Text)], ["tip", LLSTRING(fcs_target_title_Tooltip)]],
    createHashMapFromArray [["t", "kv"], ["rows", [[LLSTRING(fcs_mode_title_Text), LLSTRING(Fcs_LocalTargeting), "", LLSTRING(fcs_mode_title_Tooltip)]]]],
    createHashMapFromArray [["t", "fields"], ["items", _fields], ["enter", ["", "artCalc", _calcFields] call FUNC(webButton)]],
    createHashMapFromArray [["t", "buttons"], ["items", [
        [LLSTRING(fcs_calc_Text), "artCalc", _calcFields] call FUNC(webButton),
        [LLSTRING(fcs_prev_Text), "artPrev"] call FUNC(webButton),
        [LLSTRING(fcs_next_Text), "artNext"] call FUNC(webButton)
    ]]]
];

if (_missile) then {
    // the rocket's fuze modes, the time for a time fuze, the target of a GPS guided rocket
    private _magazineConfig = configFile >> "CfgMagazines" >> (_rounds param [_form get "round", ""]);
    private _fuzeConfig = configFile >> "ITC_Land_CfgFuzes" >> getText (_magazineConfig >> "itc_land_fuze");
    private _modes = getArray (_fuzeConfig >> "modes");
    if ((_form get "fuze") >= count _modes) then {_form set ["fuze", 0]};
    private _fuzeFields = [["fuze", LLSTRING(fci_fuzeinputs_mode_text_Text), LLSTRING(fci_fuzeinputs_mode_Tooltip), getArray (_fuzeConfig >> "modeDesc"), "artFuze"] call FUNC(webField)];
    if ((_modes param [_form get "fuze", ""]) == "time") then {
        _fuzeFields pushBack (["time", LLSTRING(fci_fuzeinputs_time_text_Text), LLSTRING(fci_fuzeinputs_time_Tooltip)] call FUNC(webField));
    };
    private _applyFields = ["round", "fuze", "time", "pgmGrid", "pgmAlt"];
    _blocks append [
        createHashMapFromArray [["t", "section"], ["text", LLSTRING(fci_fuzeinputs_Text)], ["tip", LLSTRING(fci_fuzeinputs_Tooltip)]],
        createHashMapFromArray [["t", "fields"], ["items", _fuzeFields]]
    ];
    if ((getArray (_magazineConfig >> "itc_land_guidance")) param [0, ""] == "gps_inertial") then {
        _blocks append [
            createHashMapFromArray [["t", "section"], ["text", LLSTRING(fci_guideinputs_text_Text)], ["tip", LLSTRING(fci_guideinputs_Tooltip)]],
            createHashMapFromArray [["t", "fields"], ["items", [
                ["pgmGrid", LLSTRING(fci_guideinputs_tgtgrid_text_Text)] call FUNC(webField),
                ["pgmAlt", LLSTRING(fci_guideinputs_elev_text_Text)] call FUNC(webField)
            ]]]
        ];
    };
    _blocks pushBack createHashMapFromArray [["t", "buttons"], ["items", [
        [LLSTRING(fci_guideinputs_apply_btn_Text), "artApply", _applyFields] call FUNC(webButton),
        [LLSTRING(fci_fdcorders_btn_Text), "artFdcOrders", [], LLSTRING(fci_fdcorders_btn_Tooltip)] call FUNC(webButton)
    ]]];
};

// the selected solution or the FDC's data, as the classic readout has it (one line each)
private _readout = ([_vehicle, !_missile] call FUNC(fcsSolutionText)) splitString "<>" select {_x != "br/" && {_x != ""}};
_blocks pushBack createHashMapFromArray [["t", "lines"], ["lines", _readout], ["tip", LLSTRING(fcs_results_Tooltip)]];

_view set ["title", LLSTRING(Fcs_Header)];
_view set ["blocks", _blocks];
_view
