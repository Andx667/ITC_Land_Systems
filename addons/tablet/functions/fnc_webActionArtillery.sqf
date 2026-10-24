#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's SPG and MLRS actions, as the classic FCI page's (the form holds the values the
 * page sent, see tablet_fnc_webReceive):
 *   artCalc       firing solutions on the target grid and elevation for the selected round
 *   artStep d     the solution shown in the gunner sight, one back (-1) or on (1)
 *   artApplyCalc  MLRS: artApply, then artCalc: the rockets' settings and the solution of one round
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

// MLRS: one press applies the fuze and guidance and calculates, so both are of the same round
if (_action == "artApplyCalc") exitWith {
    [_vehicle, _app, "artApply", _value] call FUNC(webActionArtillery);
    [_vehicle, _app, "artCalc", _value] call FUNC(webActionArtillery);
};

private _rounds = GVAR(web) getOrDefault ["rounds", []];
private _roundIndex = ["round", "index"] call FUNC(webFormValue);
private _round = if (_roundIndex < 0) then {""} else {_rounds param [_roundIndex, ""]};

switch (_action) do {
    case "artCalc": {
        private _solutions = [_vehicle, ["grid"] call FUNC(webFormValue), parseNumber (["elev"] call FUNC(webFormValue)), _round] call FUNC(fcsCalculate);
        if (_solutions isEqualTo []) then {[LLSTRING(Fcs_NoSolution), "warn"] call FUNC(webNotice)};
    };
    case "artStep": {
        [_vehicle, _value] call FUNC(fcsStep);
    };
    case "artFuze": {
        [_vehicle, _round, ["fuze", "index"] call FUNC(webFormValue)] call EFUNC(common,setFuzeSelection);
    };
    case "artApply": {
        if (_app != "missile") exitWith {};
        [
            _vehicle, _round, ["fuze", "index"] call FUNC(webFormValue), parseNumber (["time"] call FUNC(webFormValue)),
            ["pgmGrid"] call FUNC(webFormValue), parseNumber (["pgmAlt"] call FUNC(webFormValue))
        ] call FUNC(fcsApplyRocketSettings);
    };
    case "artFdcOrders": {
        // fill in the FDC's fire orders: round, fuze (a time fuze with the line's fuze setting) and GPS target; APPLY stays with the crew
        private _orders = [_vehicle, _rounds] call EFUNC(common,getFdcOrders);
        if (_orders isEqualTo createHashMap) exitWith {
            [LLSTRING(Fcs_NoFdcOrders), "warn"] call FUNC(webNotice);
        };
        if ((_orders get "round") == -1) exitWith {
            [format [LLSTRING(Fcs_FdcRoundMissing), getText (configFile >> "CfgMagazines" >> (_orders get "magazine") >> "displayName")], "bad"] call FUNC(webNotice);
        };
        private _form = GVAR(web) get "form";
        _form set ["round", _orders get "round"];
        if ((_orders get "fuze") != -1) then {_form set ["fuze", _orders get "fuze"]};
        if ((_orders get "time") != "") then {_form set ["time", _orders get "time"]};
        if ((_orders get "grid") != "") then {
            _form set ["pgmGrid", _orders get "grid"];
            _form set ["pgmAlt", _orders get "alt"];
        };
        [] call FUNC(webFormChanged);
        [format [LLSTRING(Fcs_FdcOrdersApplied), _orders get "mission"]] call FUNC(webNotice);
    };
};
