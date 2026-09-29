#include "..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the missile app. Checks whether the current vehicle has the required tablet interface;
 * if not, clears the app UI and shows a "no interface" message. Otherwise sets the app header/sidebar
 * labels and returns the id of the page to open by default.
 *
 * Arguments:
 * 0: The tablet dialog display <Display>
 *
 * Return Value:
 * The initial page id to load <String> ("fcs", or "" if the vehicle has no compatible interface)
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_appInit
 *
 * Public: No
 */

#include "..\..\BCS_idc_defines.hpp"

params ["_display"];
ITC_CURVEHICLE
private _interfaces = (configOf _vehicle >> "itc_land" >> "tabletInterfaces")  call BIS_fnc_getCfgData;
private _canOpen = (!isNil{_interfaces}); //can't open if there's no interfaces
if(_canOpen) then { //check if it has the right interfaces
  _canOpen = "spg" in _interfaces;
};
if(!_canOpen) exitWith {
  [_display] call FUNC(appClear);

  [_display, IDC_header1, "MLRS APP"] call FUNC(setText);
  [_display, IDC_header2, "NO INTERFACE"] call FUNC(setText);
  [_display, IDC_sidebar_button5, 1] call FUNC(setFade);
  [_display, IDC_workspace_header, "Self Propelled Gun Interface not found"] call FUNC(setText);
  ""
};

[_display, IDC_header1, "Vehicle"] call FUNC(setText);
[_display, IDC_header2, "MLRS"] call FUNC(setText);

[_display, IDC_sidebar_button1, 0] call FUNC(setFade);
[_display, IDC_sidebar_button2, 0] call FUNC(setFade);
//[_display, IDC_sidebar_button3, 0] call FUNC(setFade);
[_display, IDC_sidebar_button1, "FCI"] call FUNC(setText);
[_display, IDC_sidebar_button2, "STATUS"] call FUNC(setText);
//[_display, IDC_sidebar_button3, "Status"] call FUNC(setText);

"fcs"
