#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles the response to an ID registration request; if the registration succeeded, stores the assigned datalink ID on the target object.
 *
 * Arguments:
 * 0: Target object that requested the ID <Object>
 * 1: Received transmission [destination, origin, header, type, data] <Array>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, ["0101","0000","object_register","response",[true,"0101"]]] call itc_land_datalink_fnc_receiveIDRegistry
 *
 * Public: No
 */

 params ["_target","_transmission"];
 _transmission params ["_destination","_origin","_header","_type","_data"];

_data params ["_success","_info"];
if(_success) then {
  _target setVariable [QGVAR(id),_destination];
};
