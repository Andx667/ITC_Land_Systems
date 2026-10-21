#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Intended to refresh the artillery apps' FCS page's firing-solution readout on render; currently a no-op, as its
 * entire body is commented out.
 *
 * Arguments:
 * 0: The tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_pageRender
 *
 * Public: No
 */

/*params ["_display"];
_vehicle = [] call EFUNC(common,getCurVehicle);
//weaponState [_vehicle, [0]] params ["_weapon", "_muzzle", "_firemode", "_magazine", "_ammoCount"];

_solutions = (_vehicle getVariable "itc_land_tablet_fcs_solutions");
if(count _solutions > 0) then {
  _solutionIndex = (_vehicle getVariable "itc_land_tablet_fcs_solutions_index");
  _solution = _solutions # _solutionIndex;
  _solutionString = "";
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
*/
