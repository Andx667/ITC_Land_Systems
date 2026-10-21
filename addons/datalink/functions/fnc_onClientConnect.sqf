#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Server-side event handler for a client connection request. Auto-assigns an ID if none was supplied, validates the ID, and if it is valid and available, registers the object and the requesting machine in the node registry; sends a response transmission back to the requesting machine with the outcome.
 *
 * Arguments:
 * 0: Object requesting the connection <Object>
 * 1: Datalink ID being requested <String>
 * 2: Name of the requesting system <String>
 * 3: Machine ID (clientOwner) of the requesting machine <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "0101", "radar", 3] call itc_land_datalink_fnc_onClientConnect
 *
 * Public: No
 */

params ["_player","_id","_requestingSystem","_owner"];

//auto-assign ID if not set
if (isNil{_id} || _id == "") then {
    _id = ["01"] call FUNC(findAvailableID);
};

//validate the id
//check formating
([_id, true] call FUNC(validateID)) params ["_isValidID","_errors"];
//check if it's free
private _isAvailableID = !([itc_land_datalink_nodes, _id] call CBA_fnc_hashHasKey);
if (!_isAvailableID) then {
    _errors pushBack "ID unavailable";
};

//if valid and available then add it
private _transmission = [];
if (_isAvailableID && _isValidID) then {
    [itc_land_datalink_nodes, _id, [_player, _owner]] call CBA_fnc_hashSet;
    _transmission = [_id,"0000",_requestingSystem,"response",[true,_id]];
} else { //return errors
    _transmission = ["","0000",_requestingSystem,"response",[false,_errors]];
};

[QGVAR(clientRX), [_player, _transmission], _owner] call CBA_fnc_ownerEvent;
