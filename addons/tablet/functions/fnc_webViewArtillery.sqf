#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's SPG and MLRS apps (the classic "artillery" app with the spg and missile FCI
 * pages): the FCI page takes the target grid, elevation and round, computes the firing solutions
 * for the vehicle (tablet_fnc_webActionArtillery) and shows the selected one, or the FDC's fire
 * data; the MLRS also sets the fuze and guidance of its rockets, applied together with the
 * calculation so the two cannot differ, and fills in the FDC's orders. The status page lists
 * the vehicle's systems and fuel. Without the vehicle's SPG interface the app says so.
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
private _block = {
    params ["_type", ["_pairs", []]];
    private _map = createHashMapFromArray _pairs;
    _map set ["t", _type];
    _map
};

if !("spg" in getArray (configOf _vehicle >> "itc_land" >> "tabletInterfaces")) exitWith {
    [_app + "/none", {createHashMap}] call FUNC(webForm);
    _view set ["header1", getText (_appConfig >> "title")];
    _view set ["header2", LLSTRING(Artillery_NoInterface)];
    _view set ["title", LLSTRING(Artillery_InterfaceNotFound)];
    _view set ["blocks", [["note", [["text", LLSTRING(Artillery_InterfaceNotFound)], ["c", "warn"]]] call _block]];
    _view
};

private _page = _vehicle getVariable [QGVAR(page), "fcs"];
_view set ["side", [
    ["FCI", "page", [], LLSTRING(Fcs_Header), "fcs", _page == "fcs"] call FUNC(webButton),
    [getText (_appConfig >> "sidebar2"), "page", [], LLSTRING(Artillery_VehicleStatus), "status", _page == "status"] call FUNC(webButton)
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
        ["row", [["blocks", [
            ["list", [["header", [LLSTRING(status_dam_title_Text), ""]], ["tips", [LLSTRING(status_dam_list_Tooltip), LLSTRING(status_dam_list_Tooltip)]], ["rows", _rows]]] call _block,
            ["col", [["blocks", [
                ["section", [["text", LLSTRING(status_info_title_Text)]]] call _block,
                ["kv", [["rows", [[LLSTRING(status_info_fuel_Text), format ["%1%2", round (fuel _vehicle * 100), "%"]]]]]] call _block
            ]]]] call _block
        ]]]] call _block
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

private _grid = createHashMapFromArray [["check", ["^([0-9][0-9]){2,5}$", LLSTRING(WebCheckGrid)]], ["hint", LLSTRING(WebHintGrid)], ["max", 10]];
private _number = createHashMapFromArray [["check", ["^-?[0-9]+([.][0-9]+)?$", LLSTRING(WebCheckNumber)]], ["unit", "m"]];
private _roundNames = _rounds apply {getText (configFile >> "CfgMagazines" >> _x >> "displayName")};
private _calcFields = ["grid", "elev", "round"];
private _fields = [
    ["grid", LLSTRING(fcs_target_pos_Text), LLSTRING(fcs_target_pos_Tooltip), [], "", [], _grid] call FUNC(webField),
    ["elev", LLSTRING(fcs_target_elev_Text), LLSTRING(fcs_target_elev_Tooltip), [], "", [], _number] call FUNC(webField),
    ["round", LLSTRING(fcs_round_type_Text2), LLSTRING(fcs_round_type_Tooltip), _roundNames, ["", "artRound"] select _missile] call FUNC(webField)
];

// the MLRS: the rocket's fuze modes, the time for a time fuze, the target of a GPS guided rocket;
// applied with the calculation, so the solution and the rockets' settings are of the same round
private _fuzeFields = [];
if (_missile) then {
    private _magazineConfig = configFile >> "CfgMagazines" >> (_rounds param [_form get "round", ""]);
    private _fuzeConfig = configFile >> "ITC_Land_CfgFuzes" >> getText (_magazineConfig >> "itc_land_fuze");
    private _modes = getArray (_fuzeConfig >> "modes");
    if ((_form get "fuze") >= count _modes) then {_form set ["fuze", 0]};
    _fuzeFields pushBack (["fuze", LLSTRING(fci_fuzeinputs_mode_text_Text), LLSTRING(fci_fuzeinputs_mode_Tooltip), getArray (_fuzeConfig >> "modeDesc"), "artFuze"] call FUNC(webField));
    if ((_modes param [_form get "fuze", ""]) == "time") then {
        _fuzeFields pushBack (["time", LLSTRING(fci_fuzeinputs_time_text_Text), LLSTRING(fci_fuzeinputs_time_Tooltip), [], "", [],
            createHashMapFromArray [["check", ["^[0-9]+([.][0-9]+)?$", LLSTRING(WebCheckNumber)]], ["unit", "s"]]] call FUNC(webField));
    };
    if ((getArray (_magazineConfig >> "itc_land_guidance")) param [0, ""] == "gps_inertial") then {
        _fuzeFields pushBack (["pgmGrid", LLSTRING(fci_guideinputs_tgtgrid_text_Text), LLSTRING(fci_guideinputs_Tooltip), [], "", [], _grid] call FUNC(webField));
        _fuzeFields pushBack (["pgmAlt", LLSTRING(fci_guideinputs_elev_text_Text), LLSTRING(fci_guideinputs_Tooltip), [], "", [], _number] call FUNC(webField));
    };
    _calcFields = _calcFields + ["fuze", "time", "pgmGrid", "pgmAlt"];
};
private _calculate = if (_missile) then {
    [LLSTRING(WebApplyCalculate), "artApplyCalc", _calcFields, LLSTRING(fci_fuzeinputs_Tooltip), nil, false, "primary"] call FUNC(webButton)
} else {
    [LLSTRING(WebCalculate), "artCalc", _calcFields, LLSTRING(fcs_round_type_Tooltip), nil, false, "primary"] call FUNC(webButton)
};
private _blocks = [
    ["section", [["text", LLSTRING(fcs_target_title_Text)], ["tip", LLSTRING(fcs_target_title_Tooltip)]]] call _block,
    ["fields", [["items", _fields], ["enter", _calculate]]] call _block
];
if (_missile) then {
    _blocks pushBack (["section", [["text", LLSTRING(fci_fuzeinputs_Text)], ["tip", LLSTRING(fci_fuzeinputs_Tooltip)]]] call _block);
    _blocks pushBack (["fields", [["items", _fuzeFields], ["enter", _calculate]]] call _block);
};
private _secondary = [];
if (_missile) then {_secondary pushBack [[LLSTRING(fci_fdcorders_btn_Text), "artFdcOrders", [], LLSTRING(fci_fdcorders_btn_Tooltip)] call FUNC(webButton)]};
_blocks pushBack (["bar", [["left", [_calculate]], ["groups", _secondary]]] call _block);

// the selected solution (stepped as in the BCS) or the FDC's data, label and value
private _solutions = _vehicle getVariable ["itc_land_tablet_fcs_solutions", []];
private _solutionKey = (LLSTRING(Fcs_Solution) splitString ":") param [0, ""];
private _rows = [];
{
    private _colon = _x find ": ";
    private _row = if (_colon > 0) then {[_x select [0, _colon], _x select [_colon + 2]]} else {[_x, ""]};
    // the solution count is the stepper's
    if ((_row # 0) != _solutionKey) then {_rows pushBack _row};
} forEach (([_vehicle, !_missile] call FUNC(fcsSolutionText)) splitString "<>" select {_x != "br/" && {_x != ""}});
_blocks pushBack (["section", [["text", LLSTRING(WebSolution)], ["tip", LLSTRING(fcs_results_Tooltip)]]] call _block);
if (_solutions isNotEqualTo []) then {
    _blocks pushBack (["stepper", [
        ["label", LLSTRING(WebSolution)],
        ["value", format ["%1 / %2", (_vehicle getVariable ["itc_land_tablet_fcs_solutions_index", 0]) + 1, count _solutions]],
        ["a", "artStep"],
        ["tip", LLSTRING(solution_solutionCount_Tooltip)]
    ]] call _block);
};
_blocks pushBack (["kv", [["rows", _rows]]] call _block);
if (_solutions isEqualTo []) then {
    _blocks pushBack (["note", [["text", LLSTRING(WebNoSolutionYet)]]] call _block);
};

_view set ["title", LLSTRING(Fcs_Header)];
_view set ["blocks", _blocks];
_view
