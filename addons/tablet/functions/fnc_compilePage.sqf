#include "..\script_component.hpp"

params ["_app", "_page"];
itc_land_tablet_fnc_pageInit = compile preprocessfilelinenumbers format[QPATHTOF(functions\apps\%1\%2\init.sqf), _app, _page];
itc_land_tablet_fnc_pageInteract = compile preprocessfilelinenumbers format[QPATHTOF(functions\apps\%1\%2\interact.sqf), _app, _page];
itc_land_tablet_fnc_pageRender = compile preprocessfilelinenumbers format[QPATHTOF(functions\apps\%1\%2\render.sqf), _app, _page];
