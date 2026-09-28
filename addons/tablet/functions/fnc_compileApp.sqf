#include "..\script_component.hpp"

params ["_app"];
itc_land_tablet_fnc_appInit = compile preprocessfilelinenumbers format[QPATHTOF(functions\apps\%1\init.sqf), _app];
FUNC(appClear) = compile preprocessfilelinenumbers format[QPATHTOF(functions\apps\%1\clear.sqf), _app];
FUNC(appInteract) = compile preprocessfilelinenumbers format[QPATHTOF(functions\apps\%1\interact.sqf), _app];
itc_land_tablet_fnc_appRender = compile preprocessfilelinenumbers format[QPATHTOF(functions\apps\%1\render.sqf), _app];
