#include "..\..\..\script_component.hpp"

#include "..\..\BCS_idc_defines.hpp"

params ["_display"];
_vehicle = [] call EFUNC(common,getCurVehicle);
_interfaces = (configOf _vehicle >> "itc_land" >> "tabletInterfaces")  call BIS_fnc_getCfgData;
_canOpen = (!isNil{_interfaces}); //can't open if there's no interfaces
if(_canOpen) then { //check if it has the right interfaces
  _canOpen = "spg" in _interfaces;
};
if(!_canOpen) exitWith {
  [_display] call FUNC(appClear);

  [_display, IDC_header1, "SPG APP"] call FUNC(setText);
  [_display, IDC_header2, "NO INTERFACE"] call FUNC(setText);
  [_display, IDC_sidebar_button5, 1] call FUNC(setFade);
  [_display, IDC_workspace_header, "Self Propelled Gun Interface not found"] call FUNC(setText);
  ""
};

[_display, IDC_header1, "Vehicle"] call FUNC(setText);
[_display, IDC_header2, "SP Artillery"] call FUNC(setText);

[_display, IDC_sidebar_button1, 0] call FUNC(setFade);
[_display, IDC_sidebar_button2, 0] call FUNC(setFade);
//[_display, IDC_sidebar_button3, 0] call FUNC(setFade);
[_display, IDC_sidebar_button1, "FCI"] call FUNC(setText);
[_display, IDC_sidebar_button2, "INS / DATA"] call FUNC(setText);
//[_display, IDC_sidebar_button3, "Status"] call FUNC(setText);

"fcs"
