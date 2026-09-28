#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Datalink event callback that gathers a COBRA vehicle's tracked firing
 * positions, engagements and active shells, and transmits them back to the
 * requesting origin over the datalink.
 *
 * Arguments:
 * 0: COBRA-equipped vehicle/object the data is being requested from <Object>
 * 1: Datalink transmission array; 0: destination, 1: origin, 2: header, 3: type, 4: data <Array>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_target, _transmission] call itc_land_cobra_fnc_getCobraData
 *
 * Public: No
 */

params ["_target","_transmission"];
_transmission params ["_destination","_origin","_header","_type","_data"];

private _returnData = [
  _target,
  _target getVariable "firingPositions",
  _target getVariable "engagements",
  _target getVariable "activeShells"
];
[_origin,_target getVariable "datalink_id","cobra","returnData",_returnData] call EFUNC(datalink,transmit);
