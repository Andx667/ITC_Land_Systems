#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Unregisters a previously registered datalink event handler of the given type from an object.
 *
 * Arguments:
 * 0: Object to remove the handler from <Object>
 * 1: Transmission header the handler was registered with <String>
 * 2: Transmission type the handler was registered with <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "object_register", "response"] call itc_land_datalink_fnc_unregisterEvent
 *
 * Public: No
 */

params ["_target", "_header", "_type"];

private _functions = _target getVariable "datalink_functions";
private _indexToRemove = _functions findIf {((_x # 1) == _target && (_x # 2) == _type)};
if(_indexToRemove > -1) then {
  _functions deleteAt _indexToRemove;
};
_target setVariable ["datalink_functions",_functions];
