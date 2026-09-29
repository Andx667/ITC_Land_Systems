#include "..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles sidebar interactions for the SPG app, switching the vehicle's active tablet page based on which
 * sidebar button was pressed.
 *
 * Arguments:
 * 0: The sidebar action identifier ("side1", "side2", "side3") <String>
 * 1: The tablet dialog display <Display> (unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["side1", _display] call itc_land_tablet_fnc_appInteract
 *
 * Public: No
 */

params ["_action"];
ITC_CURVEHICLE
switch(_action) do {
  case "side1": {
    _vehicle setVariable ["page", "fcs"];
  };
  case "side2": {
    _vehicle setVariable ["page", "status"];
  };
  case "side3": {
    _vehicle setVariable ["page", "status"];
  };  
};
