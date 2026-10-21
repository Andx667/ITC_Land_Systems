#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Compiles a tablet app/page script, reusing the compiled code on later calls. With
 * DISABLE_COMPILE_CACHE defined the script is recompiled every time, so app files can be
 * edited while the game runs (file patching).
 *
 * Arguments:
 * 0: Path of the script file <STRING>
 *
 * Return Value:
 * Compiled script <CODE>
 *
 * Example:
 * ["\z\itc_land\addons\tablet\functions\apps\home\init.sqf"] call itc_land_tablet_fnc_compileScript
 *
 * Public: No
 */

params ["_path"];

#ifdef DISABLE_COMPILE_CACHE
    compile preprocessFileLineNumbers _path
#else
    GVAR(scriptCache) getOrDefaultCall [_path, {compile preprocessFileLineNumbers _path}, true]
#endif
