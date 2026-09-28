#include "..\..\..\..\script_component.hpp"

params ["_display"];
#include "..\..\..\BCS_idc_defines.hpp"
ctrlShow [13301, true];
[_display, 15010, 0] call FUNC(setFade);
[_display, 15011, 0] call FUNC(setFade);

_vehicle = [] call EFUNC(common,getCurVehicle);
_apps = _vehicle getVariable "apps";
{
  if(_x < count _apps) then {
    _name = (configFile >> "itc_land" >> "apps" >> _apps # _x >> "displayName")  call BIS_fnc_getCfgData;
    _ifaces = (configFile >> "itc_land" >> "apps" >> _apps # _x >> "interfaces")  call BIS_fnc_getCfgData;
    
    _displayedName = toUpper (format ["APP %1: %2",_x + 1, _name]);
    _displayedifaces = toUpper ( _ifaces );
    
    [_display, 91000 + _x, _displayedName] call FUNC(setText);
    [_display, 91010 + _x, _displayedifaces] call FUNC(setText);
    
  } else {
    [_display, 91000 + _x, ""] call FUNC(setText);
    [_display, 91010 + _x, ""] call FUNC(setText);
    ctrlShow [91020 + _x, false];   
  };
}forEach [0,1,2];
