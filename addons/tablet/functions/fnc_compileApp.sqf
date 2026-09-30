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
itc_land_tablet_fnc_appInit = compile preprocessFileLineNumbers ([_app, "init.sqf"] call FUNC(resolveAppFile));
FUNC(appClear) = compile preprocessFileLineNumbers ([_app, "clear.sqf"] call FUNC(resolveAppFile));
FUNC(appInteract) = compile preprocessFileLineNumbers ([_app, "interact.sqf"] call FUNC(resolveAppFile));
itc_land_tablet_fnc_appRender = compile preprocessFileLineNumbers ([_app, "render.sqf"] call FUNC(resolveAppFile));
