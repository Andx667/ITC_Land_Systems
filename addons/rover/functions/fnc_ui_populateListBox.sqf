#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Rebuilds the rover UI's aircraft list box from the currently available
 * friendly aircraft, restoring the previous selection if that aircraft is
 * still present, and updates the current selection index/aircraft globals.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_rover_fnc_ui_populateListBox
 *
 * Public: No
 */

private _aircraft = call FUNC(getAircraft);
itc_land_rover_ui_aircraftList = [objNull] + _aircraft;

lbClear 2100;
lbAdd [2100, " -- "];

{
  lbAdd [2100, (getText (configOf _x >> "displayName")) + " (" + (name _x) + ")"];
} forEach _aircraft;

private _index = missionNameSpace getVariable ["itc_land_rover_ui_curSelIndex",0];

private _curAircraft = missionNameSpace getVariable ["itc_land_rover_ui_curAircraft",objNull];
private _findAircraft = itc_land_rover_ui_aircraftList find _curAircraft;
if (_findAircraft == -1) then { _index = 0; } else { _index = _findAircraft; };

lbSetCurSel [2100,_index];

itc_land_rover_ui_curSelIndex = _index;
itc_land_rover_ui_curAircraft = itc_land_rover_ui_aircraftList # _index;
