#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS solutionMission page: shows the solutionMission workspace panel and
 * sets its header. Unless told not to, recalculates the battery/gun firing solutions for the
 * current mission; if no solutions exist, shows LLSTRING(Bcs_NoSolutions) and the range to target,
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

[_display, IDC_workspace_header, format[LLSTRING(Bcs_Solutions), _ident]] call EFUNC(common,ctrlSetText);

if (_calculate) then {
    // linked guns are where their vehicles are now
    GVAR(bcs_bty_guns) = [GVAR(bcs_bty_guns)] call EFUNC(bcs,refreshLinkedGuns);
    GVAR(bcs_solutions) = [GVAR(bcs_bty_guns),_magazineType,_tgtPos,_engagePage]  call EFUNC(bcs,calcSolutions);
};

GVAR(bcs_solutions) params ["_btySolutions", "_gunSolutions"];
GVAR(bcs_solutionRows) = [];
if (count _btySolutions == 0) exitWith {
    SETTEXT(8022,LLSTRING(Bcs_NoSolutions));
    lbClear 8500;
    SETTEXT(8018,"");//ordinate
    SETTEXT(8019,"");//angle
    SETTEXT(8020,"");//distance
    if (count GVAR(bcs_bty_guns) > 0 && {_tgtPos isEqualTypeArray [0, 0, 0]}) then {
        private _btyPos = [GVAR(bcs_bty_guns)] call EFUNC(bcs,getBatteryPosition);
        SETTEXT(8020,str round (_btyPos distance _tgtPos));//distance
    };
};
_mission set [5, (count _btySolutions) - 1];
(_btySolutions # _curSolution) params ["_charge", "_az", "_df", "_qd", "_tof", "_impVel", "_impAng", "_maxOrd", "_dist"];
SETTEXT(8018,str (round _maxOrd));//ordinate
SETTEXT(8019,str (round _impAng));//angle
SETTEXT(8020,str (round _dist));//distance
private _text = format[LLSTRING(Bcs_SolutionOf), (_curSolution + 1), count (GVAR(bcs_solutions) # 0)];
SETTEXT(8022,_text);

// each gun's line for the selected charge and angle; a gun without one (out of range, cannot lay it) shows NO SLN.
// Linked guns with an ammunition handler get its status appended by render.sqf
lbClear 8500;
{
    _x params ["_num", "_gunSolutionList"];
    private _solution = [_gunSolutionList, _btySolutions # _curSolution] call EFUNC(bcs,matchGunSolution);
    private _solText = if (_solution isEqualTo []) then {
        format ["G: %1     %2", _num, LLSTRING(Fcs_NoSolution)]
    } else {
        format [
            "G: %1     CH: %2     AZ: %3     DF: %4     QD: %5     TOF: %6",
            _num, _solution # 0, round (_solution # 1), _solution # 2, round (_solution # 3), [( _solution # 4),1,2] call CBA_fnc_formatNumber]
    };
    (_display displayCtrl 8500) lbAdd _solText;
    private _vehicle = (GVAR(bcs_bty_guns) param [GVAR(bcs_bty_guns) findIf {_x # 0 == _num}, []]) param [6, objNull];
    if (!isNumber (configOf _vehicle >> "itc_land" >> "loaderType")) then {_vehicle = objNull};
    GVAR(bcs_solutionRows) pushBack [_solText, _vehicle];
}forEach _gunSolutions;
