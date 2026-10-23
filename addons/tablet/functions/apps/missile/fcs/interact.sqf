#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles interactions on the missile FCS page. On "calc" it reads the entered target grid/elevation,
 * computes ballistic firing solutions for the selected magazine, applies a guidance azimuth override for
 * guided munitions, and stores the results on the vehicle. On "prev"/"next" it steps through the stored
 * solutions. On "setFG" it spawns a thread that determines the fuze description/value for the selected
 * fuze setting and, for GPS-inertial guided munitions, stores the entered target position on the vehicle.
 * After "calc"/"prev"/"next" it also refreshes the on-screen firing solution readout.
 *
 * Arguments:
 * 0: The interaction action identifier ("calc", "prev", "next", "setFG") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["calc"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
ITC_CURVEHICLE

switch (_action) do {
    case "calc": {
        //#include "interact_calc.sqf"
        private _gridField = ctrlText 2400;
        _vehicle setVariable ["itc_land_tablet_fcs_tgtgrid", _gridField, true];
        // a local solution replaces the one the FDC sent
        _vehicle setVariable [QEGVAR(bcs,fireData), nil, true];

        // no solution without a grid of 4 to 10 digits; ACE reads an empty grid as the map origin
        if !(_gridField regexMatch "^([0-9][0-9]){2,5}$") exitWith {
            _vehicle setVariable ["itc_land_tablet_fcs_solutions", [], true];
            _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", 0, true];
        };
        private _elField = parseNumber (ctrlText 2401);
        private _elTgt =  _elField - ace_common_mapAltitude;

        _vehicle setVariable ["itc_land_tablet_fcs_tgtelev", _elField, true];

        private _shellType = lbData[2402, (lbCurSel 2402)];
        private _targetPos = [_gridField, false] call ace_common_fnc_getMapPosFromGrid;
        private _gunPos = getPosASL _vehicle;

        private _solutions = [_shellType, _gunPos, _gunPos # 2, getDir _vehicle, _targetPos, _elTgt, _vehicle] call EFUNC(ballistics,calcShellTypeSolutions);

        // the tables can reach steeper or flatter than this launcher can lay (guided rockets: after their fixed quadrant)
        _solutions = [_vehicle, _solutions] call EFUNC(common,filterSolutionsByElevation);
        _vehicle setVariable ["itc_land_tablet_fcs_solutions", _solutions, true];
        _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", 0, true];
    };
    case "prev" : {
        private _solutionIndex = _vehicle getVariable "itc_land_tablet_fcs_solutions_index";
        _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", (_solutionIndex - 1) max 0, true];
    };
    case "next" : {
        private _solutionIndex = _vehicle getVariable "itc_land_tablet_fcs_solutions_index";
        private _solutions = _vehicle getVariable "itc_land_tablet_fcs_solutions";
        _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", (_solutionIndex + 1) min ((count _solutions) - 1), true];
    };
    case "fdcOrders": {
        // fill in the FDC's fire orders: round, fuze (a time fuze with the line's fuze setting) and GPS target; APPLY stays with the crew
        (_vehicle getVariable [QEGVAR(bcs,fireData), []]) params [["_mission", ""], "", ["_magazine", ""], "", "", ["_fuzeMode", ""], ["_targetPos", []]];
        if (_mission == "") exitWith {
            [LLSTRING(Fcs_NoFdcOrders)] call ace_common_fnc_displayTextStructured;
        };
        private _roundIndex = -1;
        for "_i" from 0 to (lbSize 2402) - 1 do {
            if (lbData [2402, _i] == _magazine) exitWith {_roundIndex = _i};
        };
        if (_roundIndex == -1) exitWith {
            [format [LLSTRING(Fcs_FdcRoundMissing), getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]] call ace_common_fnc_displayTextStructured;
        };
        lbSetCurSel [2402, _roundIndex];
        [2402, _roundIndex] call FUNC(mlrsfci_onlblselchanged_roundType);
        private _fuzeIndex = -1;
        for "_i" from 0 to (lbSize 1904) - 1 do {
            if (lbData [1904, _i] == _fuzeMode) exitWith {_fuzeIndex = _i};
        };
        if (_fuzeIndex != -1) then {
            private _fuzeSetting = ([_vehicle] call EFUNC(common,getFireSolution)) param [10, -1];
            if (_fuzeMode == "time" && {_fuzeSetting >= 0}) then {
                _vehicle setVariable ["itc_land_mlrsfci_fuzeTime", parseNumber ([_fuzeSetting, 1, 1] call CBA_fnc_formatNumber), true];
            };
            lbSetCurSel [1904, _fuzeIndex];
            [1904, _fuzeIndex] call FUNC(mlrsfci_onlblselchanged_fuzemode);
        };
        if ((getArray (configFile >> "CfgMagazines" >> _magazine >> "itc_land_guidance")) param [0, ""] == "gps_inertial" && {_targetPos isEqualTypeArray [0, 0, 0]}) then {
            ctrlSetText [1909, ([_targetPos] call ace_common_fnc_getMapGridFromPos) joinString ""];
            ctrlSetText [1911, str round (_targetPos # 2)];
        };
        [format [LLSTRING(Fcs_FdcOrdersApplied), _mission]] call ace_common_fnc_displayTextStructured;
    };
    case "setFG" : {
        private _fuze = getText (configFile >> "CfgMagazines" >> lbData [2402, lbCurSel 2402] >> "itc_land_fuze");
        private _fuzeDesc = _vehicle getVariable ["itc_land_selectedFuzeDesc", lbText [1904, lbCurSel 1904]];
        [_vehicle, lbData [1904, lbCurSel 1904], _fuzeDesc, _fuze, parseNumber (ctrlText 1906), "itc_land_mlrsfci_fuzeTime"] call EFUNC(common,resolveFuzeSetting);

        private _guidance = getArray (configFile >> "CfgMagazines" >> lbData [2402, lbCurSel 2402] >> "itc_land_guidance");

        if (_guidance isNotEqualTo []) then {
            switch (_guidance # 0) do {
                case "gps_inertial" : {
                    private _targetGrid = ctrlText 1909;
                    private _targetAlt = parseNumber(ctrlText 1911);
                    private _targetPos = [_targetGrid, _targetAlt] call EFUNC(common,gridToPos);

                    // grid and altitude are kept so the round type page can show them again
                    _vehicle setVariable ["itc_land_guidance_targetGrid", _targetGrid, true];
                    _vehicle setVariable ["itc_land_guidance_targetAlt", _targetAlt, true];
                    _vehicle setVariable ["itc_land_guidance_targetPos",_targetPos,true];
                };

                default {   };

            };
        };
    };
};
