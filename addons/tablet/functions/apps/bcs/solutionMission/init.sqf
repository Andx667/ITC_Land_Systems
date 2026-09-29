#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS solutionMission page: shows the solutionMission workspace panel and
 * sets its header. Unless told not to, recalculates the battery/gun firing solutions for the
 * current mission; if no solutions exist, shows "NO SOLUTIONS" and the range to target,
 * otherwise displays the currently selected solution's max ordinate, impact angle, distance
 * and a per-gun breakdown (charge, azimuth, deflection, quadrant, time of flight).
 *
 * Arguments:
 * 0: Tablet dialog display <Display>
 * 1: Whether to recalculate the firing solutions before rendering <Boolean> (default: true)
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562, false] call itc_land_tablet_fnc_pageInit
 *
 * Public: No
 */

params ["_display", ["_calculate", true]];
#include "..\..\..\BCS_idc_defines.hpp"
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;
ctrlShow [13506, true];

[_display, IDC_workspace_header, format["%1 Solutions", _ident]] call FUNC(setText);

if(_calculate) then {
  GVAR(bcs_solutions) = [GVAR(bcs_bty_guns),_magazineType,_tgtPos,_engagePage]  call EFUNC(bcs,calcSolutions);
};

GVAR(bcs_solutions) params ["_btySolutions", "_gunSolutions"];
if(count _btySolutions == 0) exitWith {
  SETTEXT(8022,"NO SOLUTIONS");
  lbClear 8500;
  SETTEXT(8018,"");//ordinate
  SETTEXT(8019,"");//angle
  SETTEXT(8020,"");//distance
  if(count GVAR(bcs_bty_guns) > 0) then {
    private _btyPos = [GVAR(bcs_bty_guns)] call EFUNC(bcs,getBatteryPosition);
    SETTEXT(8020,str round (_btyPos distance _tgtPos));//distance
  };
};
_mission set [5, (count _btySolutions) - 1];
(_btySolutions # _curSolution) params ["_charge", "_az", "_df", "_qd", "_tof", "_impVel", "_impAng", "_maxOrd", "_dist"];
SETTEXT(8018,str (round _maxOrd));//ordinate
SETTEXT(8019,str (round _impAng));//angle
SETTEXT(8020,str (round _dist));//distance
private _text = format["SOLUTION %1 OUT OF %2", (_curSolution + 1), count (GVAR(bcs_solutions) # 0)];
SETTEXT(8022,_text);

lbClear 8500;
{
  _x params ["_num"];
  private _solution = _gunSolutions # _forEachIndex # 1 # _curSolution;
  private _solText = format[
    "G: %1     CH: %2     AZ: %3     DF: %4     QD: %5     TOF: %6",
    _num, _solution # 0, round (_solution # 1), _solution # 2, round (_solution # 3), [( _solution # 4),1,2] call CBA_fnc_formatNumber];
  (_display displayCtrl 8500) lbAdd _solText;
}forEach GVAR(bcs_bty_guns);
