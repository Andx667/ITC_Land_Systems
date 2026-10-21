#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles interactions on the SPG FCS page. On "calc" it reads the entered target grid/elevation, computes
 * ballistic firing solutions for the selected magazine, and stores the results on the vehicle. On "prev"/"next"
 * it steps through the stored solutions. After any of these actions it refreshes the on-screen firing
 * solution readout.
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
private _display = findDisplay 32562;

switch(_action) do {
  case "calc": {
    //#include "interact_calc.sqf"
    private _gridField = ctrlText 1400;
    _vehicle setVariable ["itc_land_tablet_fcs_tgtgrid", _gridField, true];
    
    private _elField = parseNumber (ctrlText 1401);
    private _elTgt =  _elField - ace_common_mapAltitude;
    
    _vehicle setVariable ["itc_land_tablet_fcs_tgtelev", _elField, true];

    private _shellType = lbData[1402, (lbCurSel 1402)];
    
    private _targetPos = [_gridField, false] call ace_common_fnc_getMapPosFromGrid;
    
    private _gunPos = getPosASL _vehicle;
    
    private _solutions = [_shellType, _gunPos, _gunPos # 2, getDir _vehicle, _targetPos, _elTgt] call EFUNC(ballistics,calcShellTypeSolutions);
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

if (_action in ["calc","prev","next"]) then {
    private _solutions = (_vehicle getVariable "itc_land_tablet_fcs_solutions");
    if(count _solutions > 0) then {
      private _solutionIndex = (_vehicle getVariable "itc_land_tablet_fcs_solutions_index");
      private _solution = _solutions # _solutionIndex;
      private _solutionString = "";
      _solution params ["_charge", "_az", "_df", "_qd", "_tof", "_impVel", "_impAng", "_maxOrd", "_dist"];

      _solutionString = _solutionString + format [LLSTRING(Fcs_Solution) + "<br/>", _solutionIndex+1,(count _solutions)];
      _solutionString = _solutionString + format [LLSTRING(Fcs_Charge) + "<br/>", _charge];
      _solutionString = _solutionString + format [LLSTRING(Fcs_Azimuth) + "<br/>",round _az];
      _solutionString = _solutionString + format [LLSTRING(Fcs_Deflection) + "<br/>",_df];
      _solutionString = _solutionString + format [LLSTRING(Fcs_Quadrant) + "<br/>",round _qd];
      _solutionString = _solutionString + format [LLSTRING(Fcs_TimeOfFlight) + "<br/>",round _tof];
      _solutionString = _solutionString + format [LLSTRING(Fcs_MaxOrdinate) + "<br/>",round _maxOrd];
      _solutionString = _solutionString + format [LLSTRING(Fcs_TargetDistance) + "<br/>",round _dist];

      (_display displayCtrl 1100) ctrlSetStructuredText parseText _solutionString;
    } else {
      (_display displayCtrl 1100) ctrlSetStructuredText parseText LLSTRING(Fcs_NoSolution);
    };
    (_display displayCtrl 1100) ctrlCommit 0;
};
