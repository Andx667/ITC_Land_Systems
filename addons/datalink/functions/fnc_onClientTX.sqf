#include "..\script_component.hpp"

/**
 * Transmit data over datalink
 * Params:
 * - Destination id
 * - origin ID
 * - header
 * - type
 * - data
 */
params["_destination","_origin","_header","_type","_data"];

//find all targets matching the destination ID
private _targets = [_destination] call FUNC(findIDTargets);

//send it on to non-player targets
{
  [_x,_this] remoteExec ["FUNC(onClientRX)", _x, false];
}forEach _targets;
