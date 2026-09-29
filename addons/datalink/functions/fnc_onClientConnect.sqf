#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Server-side event handler for a client connection request. Auto-assigns an ID if none was supplied, validates the ID, and if it is valid and available, registers it in the node registry; sends a response transmission back to the requesting player with the outcome.
 *
 * Arguments:
 * 0: Player object requesting the connection <Object>
 * 1: Datalink ID being requested <String>
 * 2: Name of the requesting system <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "0101", "radar"] call itc_land_datalink_fnc_onClientConnect
 *
 * Public: No
 */

 params ["_player","_id","_requestingSystem"];

//auto-assign ID if not set
if(isNil{_id} || _id == "") then {
  player sideChat format["ID %1", _id];
  _id = ["01"] call FUNC(findAvailableID);
};

//validate the id
private _isAvailableID = false;
//check formating
([_id, true] call FUNC(validateID)) params ["_isValidID","_errors"];
//check if it's free
private _isAvailableID = !([itc_land_datalink_nodes, _id] call CBA_fnc_hashHasKey);
if(!_isAvailableID) then {
  _errors pushBack "ID unavailable";
};

//if valid and available then add it
private _transmission = [];
if (_isAvailableID && _isValidID) then {
  [itc_land_datalink_nodes, _id, _player] call CBA_fnc_hashSet;
  _transmission = [_id,"0000",_requestingSystem,"response",[true,_id]];
} else { //return errors
  _transmission = ["","0000",_requestingSystem,"response",[false,_errors]];
};

[QGVAR(clientRX), [_player, _transmission], _player] call CBA_fnc_targetEvent;
