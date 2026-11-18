#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Compiles the init, interact and render scripts for the given app/page
 * combination and assigns them to the global page function handles used
 * by the tablet's per-frame render loop.
 *
 * Arguments:
 * 0: App folder name <String>
 * 1: Page folder name <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["home", "main"] call itc_land_tablet_fnc_compilePage
 *
 * Public: No
 */

params [["_app", "", [""]], ["_page", "", [""]]];
FUNC(pageInit) = [[_app, format ["%1\init.sqf", _page]] call FUNC(resolveAppFile)] call FUNC(compileScript);
FUNC(pageInteract) = [[_app, format ["%1\interact.sqf", _page]] call FUNC(resolveAppFile)] call FUNC(compileScript);
FUNC(pageRender) = [[_app, format ["%1\render.sqf", _page]] call FUNC(resolveAppFile)] call FUNC(compileScript);
