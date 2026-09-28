#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Compiles the init, clear, interact and render scripts for the given
 * app and assigns them to the global app function handles used by the
 * tablet's per-frame render loop.
 *
 * Arguments:
 * 0: App folder name <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["home"] call itc_land_tablet_fnc_compileApp
 *
 * Public: No
 */

params ["_app"];
itc_land_tablet_fnc_appInit = compile preprocessFileLineNumbers format[QPATHTOF(functions\apps\%1\init.sqf), _app];
FUNC(appClear) = compile preprocessFileLineNumbers format[QPATHTOF(functions\apps\%1\clear.sqf), _app];
FUNC(appInteract) = compile preprocessFileLineNumbers format[QPATHTOF(functions\apps\%1\interact.sqf), _app];
itc_land_tablet_fnc_appRender = compile preprocessFileLineNumbers format[QPATHTOF(functions\apps\%1\render.sqf), _app];
