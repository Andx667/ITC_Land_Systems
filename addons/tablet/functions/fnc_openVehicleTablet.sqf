#include "..\script_component.hpp"

params ["_vehicle"];

_tablet = (configOf _vehicle >> "itc_land" >> "mountedTablet")  call BIS_fnc_getCfgData;

if(!isNil{_tablet}) then {
  [_tablet,_vehicle] call FUNC(open);
};
