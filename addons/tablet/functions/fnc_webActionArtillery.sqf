#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's SPG and MLRS actions, as the classic FCI page's (the form holds the values the
 * page sent, see tablet_fnc_webReceive):
 *   artCalc       firing solutions on the target grid and elevation for the selected round
 *   artPrev/Next  the solution shown in the gunner sight
 *   artRound      another round (the MLRS's fuze modes follow it)
 *   artFuze       another fuze mode
 *   artApply      MLRS: the fuze and guidance of the rockets
 *   artFdcOrders  MLRS: fill in the FDC's round, fuze and GPS target
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: App ("spg" or "missile") <STRING>
 * 2: Action <STRING>
 * 3: Value <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player, "spg", "artCalc", nil] call itc_land_tablet_fnc_webActionArtillery
 *
 * Public: No
 */

params ["_vehicle", "_app", "_action", "_value"];

private _form = GVAR(web) get "form";
private _rounds = GVAR(web) getOrDefault ["rounds", []];
private _roundIndex = _form getOrDefault ["round", 0];
private _round = if (_roundIndex isEqualType 0) then {_rounds param [_roundIndex, ""]} else {""};

switch (_action) do {
    case "artCalc": {
        private _gridField = _form getOrDefault ["grid", ""];
        if !(_gridField isEqualType "") exitWith {};
        _vehicle setVariable ["itc_land_tablet_fcs_tgtgrid", _gridField, true];
        // a local solution replaces the one the FDC sent
        _vehicle setVariable [QEGVAR(bcs,fireData), nil, true];

        // no solution without a grid of 4 to 10 digits; ACE reads an empty grid as the map origin
        if (!(_gridField regexMatch "^([0-9][0-9]){2,5}$") || {_round == ""}) exitWith {
            _vehicle setVariable ["itc_land_tablet_fcs_solutions", [], true];
            _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", 0, true];
        };
        private _elField = parseNumber (_form getOrDefault ["elev", ""]);
        _vehicle setVariable ["itc_land_tablet_fcs_tgtelev", _elField, true];

        private _targetPos = [_gridField, false] call ace_common_fnc_getMapPosFromGrid;
        private _gunPos = getPosASL _vehicle;
        private _solutions = [_round, _gunPos, _gunPos # 2, getDir _vehicle, _targetPos, _elField - ace_common_mapAltitude, _vehicle] call EFUNC(ballistics,calcShellTypeSolutions);
        // the tables can reach steeper or flatter than this gun can lay (guided rockets: after their fixed quadrant)
        _solutions = [_vehicle, _solutions] call EFUNC(common,filterSolutionsByElevation);
        _vehicle setVariable ["itc_land_tablet_fcs_solutions", _solutions, true];
        _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", 0, true];
    };
    case "artPrev": {
        private _index = _vehicle getVariable ["itc_land_tablet_fcs_solutions_index", 0];
        _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", (_index - 1) max 0, true];
    };
    case "artNext": {
        private _index = _vehicle getVariable ["itc_land_tablet_fcs_solutions_index", 0];
        private _count = count (_vehicle getVariable ["itc_land_tablet_fcs_solutions", []]);
        _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", (_index + 1) min (_count - 1) max 0, true];
    };
    case "artFuze": {
        // remembered on the vehicle like the classic fuze list (common_fnc_applyFuzeSelection)
        private _fuzeConfig = configFile >> "ITC_Land_CfgFuzes" >> getText (configFile >> "CfgMagazines" >> _round >> "itc_land_fuze");
        private _index = _form getOrDefault ["fuze", 0];
        if !(_index isEqualType 0) exitWith {};
        _vehicle setVariable ["itc_land_selectedFuzeIndex", _index, true];
        _vehicle setVariable ["itc_land_selectedFuzeMode", getArray (_fuzeConfig >> "modes") param [_index, ""], true];
        _vehicle setVariable ["itc_land_selectedFuzeDesc", getArray (_fuzeConfig >> "modeDesc") param [_index, ""], true];
    };
    case "artApply": {
        if (_app != "missile" || {_round == ""}) exitWith {};
        private _fuze = getText (configFile >> "CfgMagazines" >> _round >> "itc_land_fuze");
        private _fuzeConfig = configFile >> "ITC_Land_CfgFuzes" >> _fuze;
        private _index = _form getOrDefault ["fuze", 0];
        if !(_index isEqualType 0) then {_index = 0};
        private _mode = getArray (_fuzeConfig >> "modes") param [_index, ""];
        private _desc = getArray (_fuzeConfig >> "modeDesc") param [_index, ""];
        _vehicle setVariable ["itc_land_selectedFuzeIndex", _index, true];
        _vehicle setVariable ["itc_land_selectedFuzeMode", _mode, true];
        _vehicle setVariable ["itc_land_selectedFuzeDesc", _desc, true];
        [_vehicle, _mode, _desc, _fuze, parseNumber (_form getOrDefault ["time", "0"]), "itc_land_mlrsfci_fuzeTime"] call EFUNC(common,resolveFuzeSetting);

        if ((getArray (configFile >> "CfgMagazines" >> _round >> "itc_land_guidance")) param [0, ""] == "gps_inertial") then {
            private _targetGrid = _form getOrDefault ["pgmGrid", ""];
            private _targetAlt = parseNumber (_form getOrDefault ["pgmAlt", "0"]);
            // grid and altitude are kept so the page can show them again
            _vehicle setVariable ["itc_land_guidance_targetGrid", _targetGrid, true];
            _vehicle setVariable ["itc_land_guidance_targetAlt", _targetAlt, true];
            _vehicle setVariable ["itc_land_guidance_targetPos", [_targetGrid, _targetAlt] call EFUNC(common,gridToPos), true];
        };
    };
    case "artFdcOrders": {
        // fill in the FDC's fire orders: round, fuze (a time fuze with the line's fuze setting) and GPS target; APPLY stays with the crew
        (_vehicle getVariable [QEGVAR(bcs,fireData), []]) params [["_mission", ""], "", ["_magazine", ""], "", "", ["_fuzeMode", ""], ["_targetPos", []]];
        if (_mission == "") exitWith {
            [LLSTRING(Fcs_NoFdcOrders)] call ace_common_fnc_displayTextStructured;
        };
        private _ordered = _rounds find _magazine;
        if (_ordered == -1) exitWith {
            [format [LLSTRING(Fcs_FdcRoundMissing), getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]] call ace_common_fnc_displayTextStructured;
        };
        _form set ["round", _ordered];
        private _fuzeIndex = getArray (configFile >> "ITC_Land_CfgFuzes" >> getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_fuze") >> "modes") find _fuzeMode;
        if (_fuzeIndex != -1) then {
            _form set ["fuze", _fuzeIndex];
            private _fuzeSetting = ([_vehicle] call EFUNC(common,getFireSolution)) param [10, -1];
            if (_fuzeMode == "time" && {_fuzeSetting >= 0}) then {
                _form set ["time", [_fuzeSetting, 1, 1] call CBA_fnc_formatNumber];
            };
        };
        if ((getArray (configFile >> "CfgMagazines" >> _magazine >> "itc_land_guidance")) param [0, ""] == "gps_inertial" && {_targetPos isEqualTypeArray [0, 0, 0]}) then {
            _form set ["pgmGrid", ([_targetPos] call ace_common_fnc_getMapGridFromPos) joinString ""];
            _form set ["pgmAlt", str round (_targetPos # 2)];
        };
        // the page drops what was typed and shows these
        GVAR(web) set ["formRev", (GVAR(web) get "formRev") + 1];
        [format [LLSTRING(Fcs_FdcOrdersApplied), _mission]] call ace_common_fnc_displayTextStructured;
    };
};
