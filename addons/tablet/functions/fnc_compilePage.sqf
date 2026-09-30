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

params ["_app", "_page"];
itc_land_tablet_fnc_pageInit = compile preprocessFileLineNumbers ([_app, format ["%1\init.sqf", _page]] call FUNC(resolveAppFile));
itc_land_tablet_fnc_pageInteract = compile preprocessFileLineNumbers ([_app, format ["%1\interact.sqf", _page]] call FUNC(resolveAppFile));
itc_land_tablet_fnc_pageRender = compile preprocessFileLineNumbers ([_app, format ["%1\render.sqf", _page]] call FUNC(resolveAppFile));
