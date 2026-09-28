#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles a tablet interaction. If the action is "app", switches the
 * current vehicle's active app to the one at the given index. Otherwise
 * forwards the action/value to the current app's interact function and
 * returns the resulting page.
 *
 * Arguments:
 * 0: Interaction action identifier <String>
 * 1: Value associated with the action (e.g. app index) <Number>
 *
 * Return Value:
 * Page identifier returned by the app's interact function <String>
 *
 * Example:
 * ["app", 1] call itc_land_tablet_fnc_interact
 *
 * Public: No
 */

params ["_action", "_value"];
_vehicle = [] call EFUNC(common,getCurVehicle);

if(_action == "app" && !isNil{_value}) exitWith {
  if(count (_vehicle getVariable "apps") > _value) then {
    _newApp = (_vehicle getVariable "apps") # _value;
    if(!isNil{_newApp}) then {
      _vehicle setVariable ["app", _newApp];
    };
  };
};

_display = findDisplay 32562;
_app = _vehicle getVariable "app";
_page = [_action, _display] call FUNC(appInteract);
