#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Registers an event handler function on an object, to be called when a datalink transmission matching the given header and type is received by that object.
 *
 * Arguments:
 * 0: Object to register the handler on <Object>
 * 1: Transmission header to match <String>
 * 2: Transmission type to match <String>
 * 3: Code to execute when a matching transmission is received <Code>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "object_register", "response", { _this call FUNC(receiveIDRegistry); }] call itc_land_datalink_fnc_registerEvent
 *
 * Public: No
 */

params ["_target", "_header", "_type", "_code"];

private _functions = _target getVariable ["datalink_functions",[]];
_functions pushBack _this;
_target setVariable ["datalink_functions",_functions];
