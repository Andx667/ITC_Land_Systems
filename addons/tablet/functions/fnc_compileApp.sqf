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

params [["_app", "", [""]]];
FUNC(appInit) = [[_app, "init.sqf"] call FUNC(resolveAppFile)] call FUNC(compileScript);
FUNC(appClear) = [[_app, "clear.sqf"] call FUNC(resolveAppFile)] call FUNC(compileScript);
FUNC(appInteract) = [[_app, "interact.sqf"] call FUNC(resolveAppFile)] call FUNC(compileScript);
FUNC(appRender) = [[_app, "render.sqf"] call FUNC(resolveAppFile)] call FUNC(compileScript);
