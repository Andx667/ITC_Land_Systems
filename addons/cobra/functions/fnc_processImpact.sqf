#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Records a predicted shell impact (position and calculated impact time) in
 * the mission's active-shells list, then triggers any COBRA-linked sirens
 * within range of the impact point.
 *
 * Arguments:
 * 0: COBRA radar vehicle that detected the shell (unused in body) <Object>
 * 1: Impact data array as returned by fnc_calcImpact: position (ASL) and time of flight <Array>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_cbr, _impact] call itc_land_cobra_fnc_processImpact
 *
 * Public: No
 */

params ["_cbr", "_impact"];
_impact params ["_position", "_tof"];
private _impacts = missionNamespace getVariable "itc_land_cobra_activeShells";
private _impactTime = cba_missionTime + _tof;
_impacts pushBack [_position, _impactTime];

missionNamespace setVariable ["itc_land_cobra_activeShells",_impacts];

private _sirenTypes = [0] call FUNC(sirenTypes);

{
  [_x, _position, _impactTime] call FUNC(sirenTrigger);
}forEach (nearestObjects [_position, _sirenTypes,500]);
//["0000",_cbr getVariable "datalink_id","cobra","shellDetected",_impact] call EFUNC(datalink,transmit);
