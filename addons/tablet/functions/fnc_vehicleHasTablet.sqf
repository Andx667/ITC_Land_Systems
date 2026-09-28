#include "..\script_component.hpp"

params ["_vehicle"];

_tablet = (configOf _vehicle >> "itc_land" >> "mountedTablet")  call BIS_fnc_getCfgData;
(!isNil{_tablet})
