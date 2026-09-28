#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Validates the given origin and destination datalink IDs and, if both are valid, broadcasts the transmission to the server via the clientTX event for delivery to matching targets.
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
 * ["0101","0202","object_register","request",[]] call itc_land_datalink_fnc_transmit
 *
 * Public: No
 */

params["_destination","_origin","_header","_type","_data"];
private _validDestination = [_destination, false, true] call FUNC(validateID);
private _validOrigin = [_origin] call FUNC(validateID);

if(_validDestination && _validOrigin) then {
  ["clientTX", [_destination,_origin,_header,_type,_data]] call CBA_fnc_serverEvent;
};
