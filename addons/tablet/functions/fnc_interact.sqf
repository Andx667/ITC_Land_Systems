#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles a tablet interaction. If the action is "app", switches the
 * current vehicle's active app to the one at the given index, or to the
 * home screen when the tablet has no app at that index. Otherwise
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
ITC_CURVEHICLE

if(_action == "app" && !isNil{_value}) exitWith {
  private _apps = _vehicle getVariable [QGVAR(apps), []];
  // App buttons without an app behind them return to the home screen (the app list)
  private _newApp = _apps param [_value, "home"];
  _vehicle setVariable [QGVAR(app), _newApp];
};

private _display = findDisplay 32562;
[_action, _display] call FUNC(appInteract);
