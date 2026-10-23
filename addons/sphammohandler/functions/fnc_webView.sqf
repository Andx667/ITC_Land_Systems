#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The ammunition handler in HTML (a panel of the tablet's web page, tablet_fnc_webState), as the
 * classic dialog: the rounds the vehicle carries, the round to prepare with its charge, fuze and
 * guidance, the count (not for a mortar), FDC ORDERS, APPLY SETTINGS and LOAD / UNLOAD (a mortar:
 * PREPARE / FIRE, STOW), and the applied settings with the loader status. It works on the same
 * vehicle variables as the classic dialog, so the crew sees the same handler in either.
 * The actions are in sphammohandler_fnc_webAction.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * View <HASHMAP>
 *
 * Example:
 * [vehicle player] call itc_land_sphammohandler_fnc_webView
 *
 * Public: No
 */

params ["_vehicle"];

private _web = EGVAR(tablet,web);
private _mortar = getNumber (configOf _vehicle >> "itc_land" >> "loaderType") == 3;

// the rounds carried, counted as in the classic list (not the charge magazines)
private _carried = ((magazines _vehicle) select {getNumber (configFile >> "CfgMagazines" >> _x >> "itc_land_CountInAH") == 1}) call BIS_fnc_consolidateArray;
_web set ["ammoList", _carried apply {_x # 0}];

private _form = [format ["ammo/%1", netId _vehicle], {createHashMapFromArray [
    ["ammo", ((_vehicle getVariable ["itc_land_currentMagInfo", [0]]) # 0) max 0],
    ["fuze", (_vehicle getVariable ["itc_land_selectedFuzeIndex", 0]) max 0],
    ["time", str (_vehicle getVariable ["itc_land_fuzeTime", 0])],
    ["code1", str (_vehicle getVariable ["itc_land_guidance_laserCode", 1111])],
    ["code2", str (_vehicle getVariable ["itc_land_guidance_laserCode_2", 1112])],
    ["grid", format ["%1", _vehicle getVariable ["itc_land_guidance_targetGrid", "00000000"]]],
    ["alt", str (_vehicle getVariable ["itc_land_guidance_targetAlt", 0])],
    ["count", str (_vehicle getVariable ["itc_land_roundCount", 0])]
]}] call EFUNC(tablet,webForm);

// the round to prepare; the vehicle keeps it, as the classic list does
private _index = ((_form get "ammo") min (count _carried - 1)) max 0;
_form set ["ammo", _index];
private _magazine = (_carried param [_index, [""]]) # 0;
private _magazineConfig = configFile >> "CfgMagazines" >> _magazine;
if (_magazine != "" && {((_vehicle getVariable ["itc_land_currentMagInfo", []]) param [1, ""]) != _magazine}) then {
    _vehicle setVariable ["itc_land_currentMagInfo", [_index, _magazine, _magazineConfig], true];
};
private _maxCharge = getNumber (_magazineConfig >> "itc_land_maxChargeIndex");
private _charge = _vehicle getVariable ["itc_land_currentChargeIndex", 1];

private _fuzeConfig = configFile >> "ITC_Land_CfgFuzes" >> getText (_magazineConfig >> "itc_land_fuze");
private _modes = getArray (_fuzeConfig >> "modes");
if ((_form get "fuze") >= count _modes) then {_form set ["fuze", 0]};
private _guidance = (getArray (_magazineConfig >> "itc_land_guidance")) param [0, ""];

// the checks and units of the fields, as the tablet's
private _check = {
    params ["_regex", "_message", ["_unit", ""]];
    private _extras = createHashMapFromArray [["check", [_regex, _message]]];
    if (_unit != "") then {_extras set ["unit", _unit]};
    _extras
};
private _number = "^-?[0-9]+([.][0-9]+)?$";
private _fields = [[
    "fuze", LLSTRING(fuze_type_Text), "", [getArray (_fuzeConfig >> "modeDesc"), ["-"]] select (_modes isEqualTo []), "ahFuze"
] call EFUNC(tablet,webField)];
if ((_modes param [_form get "fuze", ""]) == "time") then {
    _fields pushBack (["time", LLSTRING(fuzeTime_Text), "", [], "", [], [_number, LELSTRING(tablet,WebCheckNumber), "s"] call _check] call EFUNC(tablet,webField));
};
private _laser = ["^1[1-7][1-8][1-8]$", LELSTRING(tablet,WebCheckLaser)] call _check;
if (_guidance in ["laser_coded", "laser_coded_2"]) then {_fields pushBack (["code1", LLSTRING(laserCode_Text), "", [], "", [], _laser] call EFUNC(tablet,webField))};
if (_guidance == "laser_coded_2") then {_fields pushBack (["code2", LLSTRING(laserCode_Text), "", [], "", [], _laser] call EFUNC(tablet,webField))};
if (_guidance == "gps_inertial") then {
    private _grid = ["^([0-9][0-9]){2,5}$", LELSTRING(tablet,WebCheckGrid)] call _check;
    _grid set ["max", 10];
    _fields pushBack (["grid", LLSTRING(gridText_Text), "", [], "", [], _grid] call EFUNC(tablet,webField));
    _fields pushBack (["alt", LLSTRING(altText_Text), "", [], "", [], [_number, LELSTRING(tablet,WebCheckNumber), "m"] call _check] call EFUNC(tablet,webField));
};
if (!_mortar) then {
    _fields pushBack (["count", LLSTRING(countText_Text), LELSTRING(tablet,WebCountTip), [], "", [], ["^[0-9]+$", LELSTRING(tablet,WebCheckCount)] call _check] call EFUNC(tablet,webField));
};
private _settingFields = ["fuze", "time", "code1", "code2", "grid", "alt", "count"];

// the buttons as the classic dialog enables them (sphammohandler_fnc_updateStatus)
(_vehicle getVariable ["itc_land_ammoHandler_status", [0, 0, LSTRING(Status_Waiting)]]) params ["_status", "", "_statusText"];
private _button = {
    params ["_label", "_action", "_enabled", ["_send", []], ["_tip", ""], "_value", ["_kind", ""]];
    [_label, _action, _send, _tip, _value, false, _kind, !_enabled] call EFUNC(tablet,webButton)
};

// the applied settings the loader works with, and whether the form still shows them
private _settings = _vehicle getVariable ["itc_land_sphloadersettings", []];
(_settings param [0, []]) params ["", ["_appliedMagazine", ""], ["_appliedCharge", -1], ["_appliedCount", 0]];
private _isApplied = _settings isNotEqualTo []
    && {_appliedMagazine == _magazine}
    && {_appliedCharge == _charge}
    && {((_settings param [1, []]) param [1, ""]) == (_modes param [_form get "fuze", ""])}
    && {_mortar || {_appliedCount == parseNumber format ["%1", _form get "count"]}};

// the buttons as the classic dialog enables them (sphammohandler_fnc_updateStatus); the main one is
// APPLY while the settings shown are not applied, then LOAD
private _canApply = _status in [0, 1];
private _canLoad = _status in [1, 3];
private _loadLabel = if (_status == 3) then {[LLSTRING(Unload), LLSTRING(FireRound)] select _mortar} else {[LLSTRING(Load), LLSTRING(PrepareRound)] select _mortar};
private _mainButtons = [
    [LLSTRING(applyButton_Text), "ahApply", _canApply, _settingFields, "", nil, ["", "primary"] select (_canApply && {!_isApplied})] call _button,
    [_loadLabel, "ahLoad", _canLoad, [], ["", LELSTRING(tablet,WebLoadNeedsApply)] select (_status == 0), nil, ["", "primary"] select (_canLoad && {_isApplied || _status == 3})] call _button
];
if (_mortar) then {_mainButtons pushBack ([LLSTRING(stowButton_Text), "ahStow", _status == 3] call _button)};
private _applied = [
    [LLSTRING(AL_Round_Text), _settings param [0, ["-- N/A --"]] param [0, "-- N/A --"]],
    [LLSTRING(AL_Fuze_Text), _settings param [1, ["-- N/A --"]] param [0, "-- N/A --"]],
    [LLSTRING(AL_GUIDED_Text), _settings param [2, ["-- N/A --"]] param [0, "-- N/A --"]]
];
if (!_mortar) then {
    private _count = (_settings param [0, []]) param [3, 0];
    _applied pushBack [LLSTRING(AL_COUNT_Text), [str _count, "-- N/A --"] select (_count < 1)];
};
_applied pushBack [LLSTRING(status_Text), localize _statusText, "ok"];
_applied pushBack ["", [LELSTRING(tablet,WebNotApplied), LELSTRING(tablet,WebApplied)] select _isApplied, ["warn", "ok"] select _isApplied];

private _block = {
    params ["_type", ["_pairs", []]];
    private _map = createHashMapFromArray _pairs;
    _map set ["t", _type];
    _map
};
createHashMapFromArray [
    ["layout", "panel"],
    ["title", ["G15X: AMMO HANDLER & AUTOLOADER", LLSTRING(MortarHeader)] select _mortar],
    ["side", []],
    ["blocks", [
        ["row", [["blocks", [
            ["list", [["id", "ammo"], ["a", "ahAmmo"], ["rows", _carried apply {[_x # 1, getText (configFile >> "CfgMagazines" >> _x # 0 >> "displayName")]}]]] call _block,
            ["col", [["blocks", [
                ["kv", [["rows", [[LLSTRING(round_name_Text), getText (_magazineConfig >> "displayName"), "ok"]]]]] call _block,
                ["stepper", [["label", LLSTRING(chargebutton_label_Text)], ["value", format ["%1 / %2", _charge, _maxCharge]], ["a", "ahCharge"]]] call _block,
                ["fields", [["items", _fields]]] call _block,
                ["bar", [
                    ["left", [[LLSTRING(fdcOrdersButton_Text), "ahFdcOrders", true, [], LLSTRING(fdcOrdersButton_Tooltip)] call _button]],
                    ["groups", [_mainButtons]]
                ]] call _block
            ]]]] call _block,
            ["col", [["blocks", [
                ["section", [["text", [LLSTRING(AL_Header_Text), LLSTRING(LoaderHeader)] select _mortar]]] call _block,
                ["kv", [["rows", _applied]]] call _block
            ]]]] call _block
        ]]]] call _block
    ]]
]
