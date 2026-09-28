#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Connects an object to the datalink server, requesting a new ID for the given system (or validating an explicitly supplied one), and optionally auto-storing the assigned ID on the target once the server responds.
 *
 * Arguments:
 * 0: Object connecting to the datalink <Object> (default: player)
 * 1: Datalink ID to request <String> (default: "")
 * 2: Name of the requesting system <String>
 * 3: Automatically receive and store the assigned ID on the target <Boolean> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "", "radar", true] call itc_land_datalink_fnc_connect
 *
 * Public: No
 */

params[["_object",player],["_id",""],"_system",["_autoStore", false]];

if(_autoStore) then {
  [_object, "object_register", "response", {
    _this call FUNC(receiveIDRegistry);
  }] call FUNC(registerEvent);
};

["clientConnect",[_object, _id, _system]] call CBA_fnc_serverEvent;
