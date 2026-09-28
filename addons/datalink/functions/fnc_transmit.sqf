#include "..\script_component.hpp"

/**
 * Transmit data over datalink
 * Params
 * - Destination id
 * - origin ID
 * - header
 * - type
 * - data
 */
params["_destination","_origin","_header","_type","_data"];
private _validDestination = [_destination, false, true] call FUNC(validateID);
private _validOrigin = [_origin] call FUNC(validateID);

if(_validDestination && _validOrigin) then {
  ["clientTX", [_destination,_origin,_header,_type,_data]] call CBA_fnc_serverEvent;
};
