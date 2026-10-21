#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Server-side event handler that relays a transmission out to all targets currently registered under the destination ID, on the machine that connected each target.
 *
 * Arguments:
 * 0: Destination datalink ID <String>
 * 1: Origin datalink ID <String>
 * 2: Transmission header <String>
 * 3: Transmission type <String>
 * 4: Transmission payload <Array>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["0101","0202","object_register","request",[]] call itc_land_datalink_fnc_onClientTX
 *
 * Public: No
 */

params["_destination","_origin","_header","_type","_data"];

//find all targets matching the destination ID
private _targets = [_destination] call FUNC(findIDTargets);

//send it on to each target's connecting machine
{
    _x params ["_target", "_owner"];
    [QGVAR(clientRX), [_target, _this], _owner] call CBA_fnc_ownerEvent;
}forEach _targets;
