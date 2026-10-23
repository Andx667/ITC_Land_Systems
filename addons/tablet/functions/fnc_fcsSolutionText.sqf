#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Builds the SPG app's readout of the vehicle's selected fire solution: where it came from when
 * the FDC sent it (mission, ADJ/FFE, round), then solution number, charge, azimuth, deflection,
 * quadrant, time of flight, maximum ordinate and distance, or NO SLN.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Structured text string <STRING>
 *
 * Example:
 * [vehicle player] call itc_land_tablet_fnc_fcsSolutionText
 *
 * Public: No
 */

params ["_vehicle"];

private _text = "";
(_vehicle getVariable [QEGVAR(bcs,fireData), []]) params [["_mission", ""], ["_phase", ""], ["_magazine", ""]];
if (_mission != "") then {
    _text = format [LLSTRING(Fcs_FromFdc) + "<br/>", _mission, _phase, getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")];
};

private _solutions = _vehicle getVariable ["itc_land_tablet_fcs_solutions", []];
if (_solutions isEqualTo []) exitWith {_text + LLSTRING(Fcs_NoSolution)};

private _solutionIndex = _vehicle getVariable ["itc_land_tablet_fcs_solutions_index", 0];
(_solutions # _solutionIndex) params ["_charge", "_az", "_df", "_qd", "_tof", "_impVel", "_impAng", "_maxOrd", "_dist"];

_text = _text + format [LLSTRING(Fcs_Solution) + "<br/>", _solutionIndex + 1, count _solutions];
_text = _text + format [LLSTRING(Fcs_Charge) + "<br/>", _charge];
_text = _text + format [LLSTRING(Fcs_Azimuth) + "<br/>", round _az];
_text = _text + format [LLSTRING(Fcs_Deflection) + "<br/>", _df];
_text = _text + format [LLSTRING(Fcs_Quadrant) + "<br/>", round _qd];
_text = _text + format [LLSTRING(Fcs_TimeOfFlight) + "<br/>", round _tof];
_text = _text + format [LLSTRING(Fcs_MaxOrdinate) + "<br/>", round _maxOrd];
_text + format [LLSTRING(Fcs_TargetDistance) + "<br/>", round _dist]
