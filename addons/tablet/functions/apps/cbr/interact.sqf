#include "..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles CBR app-level sidebar interactions. Depending on the pressed sidebar button ("side2"/"side3"),
 * stores the target page name ("map"/"data") on the current vehicle so the tablet framework switches to
 * it (the "side1"/Settings and "side5"/refresh-data cases are currently disabled).
 *
 * Arguments:
 * 0: The sidebar button identifier that was pressed <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["side2", _display] call itc_land_tablet_fnc_appInteract;
 *
 * Public: No
 */

params ["_action"];
ITC_CURVEHICLE
switch(_action) do {
  //case "side1": {
  //  _vehicle setVariable ["page", "settings"];
  //};
  case "side2": {
    _vehicle setVariable ["page", "map"];
  };
  case "side3": {
    _vehicle setVariable ["page", "data"];
  };
  //case "side5": {
  //  [player getVariable ["itc_land_cobra_id","xxxx"],"AB01","cobra","getData",""] call EFUNC(datalink,transmit);
  //};
};
