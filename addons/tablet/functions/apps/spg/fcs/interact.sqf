#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles interactions on the SPG FCS page. On "calc" it reads the entered target grid/elevation, computes
 * ballistic firing solutions for the selected magazine, and stores the results on the vehicle. On "prev"/"next"
 * it steps through the stored solutions. The page's render.sqf redraws the readout. A local solution
 * drops the fire data the FDC sent (itc_land_bcs_fireData).
 *
 * Arguments:
 * 0: The interaction action identifier ("calc", "prev", "next") <String>
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
        private _gridField = ctrlText 1400;
        _vehicle setVariable ["itc_land_tablet_fcs_tgtgrid", _gridField, true];
        // a local solution replaces the one the FDC sent
        _vehicle setVariable [QEGVAR(bcs,fireData), nil, true];

        // no solution without a grid of 4 to 10 digits; ACE reads an empty grid as the map origin
        if !(_gridField regexMatch "^([0-9][0-9]){2,5}$") exitWith {
            _vehicle setVariable ["itc_land_tablet_fcs_solutions", [], true];
            _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", 0, true];
        };

        private _elField = parseNumber (ctrlText 1401);
        private _elTgt =  _elField - ace_common_mapAltitude;

        _vehicle setVariable ["itc_land_tablet_fcs_tgtelev", _elField, true];

        private _shellType = lbData[1402, (lbCurSel 1402)];

        private _targetPos = [_gridField, false] call ace_common_fnc_getMapPosFromGrid;

        private _gunPos = getPosASL _vehicle;

        private _solutions = [_shellType, _gunPos, _gunPos # 2, getDir _vehicle, _targetPos, _elTgt] call EFUNC(ballistics,calcShellTypeSolutions);
        // the tables can reach steeper or flatter than this gun can lay
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
};
