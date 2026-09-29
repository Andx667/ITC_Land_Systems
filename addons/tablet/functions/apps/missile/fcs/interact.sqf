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
private _curMag = (currentMagazine _vehicle);
private _display = findDisplay 32562;

switch(_action) do {
  case "calc": {
    //#include "interact_calc.sqf"
    private _gridField = ctrlText 2400;
    _vehicle setVariable ["itc_land_tablet_fcs_tgtgrid", _gridField, true];
    private _elField = parseNumber (ctrlText 2401);
    private _elTgt =  _elField - ace_common_mapAltitude;

    _vehicle setVariable ["itc_land_tablet_fcs_tgtelev", _elField, true];

    private _shellType = lbData[2402, (lbCurSel 2402)];
    private _targetPos = [_gridField, false] call ace_common_fnc_getMapPosFromGrid;
    private _gunPos = getPosASL _vehicle;

    private _solutions = [_shellType, _gunPos, _gunPos # 2, getDir _vehicle, _targetPos, _elTgt] call EFUNC(ballistics,calcShellTypeSolutions);

    itc_land_guidance = getArray (configFile >> "CfgMagazines" >> lbData [2402, lbCurSel 2402] >> "itc_land_guidance");

    if (itc_land_guidance isNotEqualTo []) then {
        if (count _solutions > 0) then {
            _solutions apply {
                _x set [3,800];
            };
        };
    };
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
  case "setFG" : {
    [_vehicle,_curMag] spawn {
        params ["_vehicle","_curMag"];
        disableSerialization;
        private _fuze  = getText (configFile >> "CfgMagazines" >> lbData [2402, lbCurSel 2402] >> "itc_land_fuze");

       //private _fuzeValues = _vehicle getVariable ["itc_land_fuzeValues",0];
        //if (isNil "itc_land_fuzeDesc") then { itc_land_fuzeDesc = lbText [1904,itc_land_selectedFuzeIndex]; };
        private _fuzeDesc = _vehicle getVariable ["itc_land_selectedFuzeDesc",(lbText [1904,lbCurSel 1904])];
        private _fuzeValues = _vehicle getVariable ["itc_land_fuzeValues",0];

        switch (lbData [1904, lbCurSel 1904 ]) do {
            case "pd" : {
                private _fuzeText = _fuzeDesc;
            };
            case "prox" : {
                private _proxHOB = getNumber (configFile >> "ITC_Land_CfgFuzes" >> _fuze >> "proxHOB");
                //itc_land_fuzeValues = _proxHOB;
                _vehicle setVariable ["itc_land_fuzeValues",_proxHOB,true];
                private _fuzeText = format ["%1: %2m",_fuzeDesc,_proxHOB];
            };
            case "time" : {
                private _fuzeTime = parseNumber(ctrlText 1906);
                _vehicle setVariable ["itc_land_fuzeValues",_fuzeTime,true];
                _vehicle setVariable ["itc_land_mlrsfci_fuzeTime",_fuzeTime,true];
                private _fuzeText = format ["%1: %2s",_fuzeDesc,_fuzeTime];
            };
            case "delay" : {
                _vehicle setVariable ["itc_land_fuzeValues",0.005,true];
                private _fuzeText = _fuzeDesc;
            };
        };
    };

    private _guidance = getArray (configFile >> "CfgMagazines" >> lbData [2402, lbCurSel 2402] >> "itc_land_guidance");

    if (_guidance isNotEqualTo []) then {
        switch (_guidance # 0) do {
            case "gps_inertial" : {
                private _targetGrid = ctrlText 1909;
                //player sidechat itc_land_guidance_targetGrid;
                private _targetPos = [_targetGrid,true] call CBA_fnc_mapGridToPos;
                //player sidechat str _targetPos;
                private _targetAlt = parseNumber(ctrlText 1911);
                _targetPos set [2,(_targetAlt - ace_common_mapAltitude)];
                //player sidechat str _targetPos;

                _vehicle setVariable ["itc_land_guidance_targetPos",_targetPos,true];
            };

            default {   };

        };
    };
  };
};

if (_action in ["calc","prev","next"]) then {
    private _solutions = (_vehicle getVariable "itc_land_tablet_fcs_solutions");

    if(count _solutions > 0) then {
      private _solutionIndex = (_vehicle getVariable "itc_land_tablet_fcs_solutions_index");
      private _solution = _solutions # _solutionIndex;
      private _solutionString = "";
      _solution params ["_charge", "_az", "_df", "_qd", "_tof", "_impVel", "_impAng", "_maxOrd", "_dist"];

      _solutionString = _solutionString + format ["SLN: %1 / %2<br/>", _solutionIndex+1,(count _solutions)];
      _solutionString = _solutionString + format ["AZIMUTH: %1<br/>",round _az];
      _solutionString = _solutionString + format ["DEFLECTION: %1<br/>",_df];

      _solutionString = _solutionString + format ["QUADRANT: %1<br/>",round _qd];
      _solutionString = _solutionString + format ["TOF: %1<br/>",round _tof];
      _solutionString = _solutionString + format ["MAXIMUM ORDINATE: %1<br/>",round _maxOrd];
      _solutionString = _solutionString + format ["TARGET DISTANCE: %1<br/>",round _dist];

      (_display displayCtrl 2403) ctrlSetStructuredText parseText _solutionString;
    } else {
      (_display displayCtrl 2403) ctrlSetStructuredText parseText "NO SLN";
    };
    (_display displayCtrl 2403) ctrlCommit 0;
};
