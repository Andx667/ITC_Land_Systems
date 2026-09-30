#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Finds the script file of a tablet app or page. Apps that declare a "sharedApp" in the tablet
 * config fall back to that app's folder for every file they don't provide themselves, so apps
 * with identical behaviour share one implementation.
 *
 * Arguments:
 * 0: App name <STRING>
 * 1: File path relative to the app folder, e.g. "init.sqf" or "fcs\render.sqf" <STRING>
 *
 * Return Value:
 * Path of the script file <STRING>
 *
 * Example:
 * ["missile", "status\render.sqf"] call itc_land_tablet_fnc_resolveAppFile
 *
 * Public: No
 */

params ["_app", "_file"];

private _path = format [QPATHTOF(functions\apps\%1\%2), _app, _file];
if (fileExists _path) exitWith {_path};

format [QPATHTOF(functions\apps\%1\%2), getText (configFile >> "itc_land" >> "apps" >> _app >> "sharedApp"), _file]
