#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Server-side event handler for a client disconnection request. Removes the given ID from the node registry, or, if no ID is given, removes every ID currently registered to the player.
 *
 * Arguments:
 * 0: Player object disconnecting <Object>
 * 1: Datalink ID to remove <String> (default: "", removes all IDs belonging to the player)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "0101"] call itc_land_datalink_fnc_onClientDisconnect
 *
 * Public: No
 */

params ["_player","_id"];

//remove all IDs with this target
if(isNil {_id} || _id == "") then {
  [0, _player] call FUNC(removeNodes);
} else {
  [itc_land_datalink_nodes,_id] call CBA_fnc_hashRem;
};
