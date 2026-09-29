#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles an incoming datalink transmission received by a non-player object, dispatching it to any handler functions the object has registered (via registerEvent) whose header and type match the transmission.
 *
 * Arguments:
 * 0: Object receiving the transmission <Object>
 * 1: Received transmission [destination, origin, header, type, data] <Array>
 *
 * Return Value:
 * None
 *
 * Example:
 * [uav1, ["0101","0202","object_register","response",[true,"0101"]]] call itc_land_datalink_fnc_onClientRX
 *
 * Public: No
 */

params ["_object","_transmission"];
_transmission params ["_destination","_origin","_header","_type","_data"];

private _datalinkMethods = _object getVariable [QGVAR(functions),[]];
{
  _x params ["_target", "_rxheader", "_rxtype", "_code"];
  if(_header == _rxheader && _type == _rxtype) then {
    [_object, _transmission] call _code;
  };
}forEach _datalinkMethods;
