#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Disconnects an object from the datalink server, removing the given ID (or, if no ID is given, every ID currently registered to the object) from the server's node registry.
 *
 * Arguments:
 * 0: Object disconnecting from the datalink <Object> (default: player)
 * 1: Datalink ID to remove <String> (default: "", removes all IDs belonging to the object)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "0101"] call itc_land_datalink_fnc_disconnect
 *
 * Public: No
 */

params[["_object",player],["_id",""]];

[QGVAR(clientDisconnect),[_object, _id]] call CBA_fnc_serverEvent;
