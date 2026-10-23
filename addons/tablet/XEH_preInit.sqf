#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.inc.sqf"

// [control, [action, ...]] call GVAR(webAction): ctrlWebBrowserAction (Arma 3 2.20) is missing from
// the arma3-wiki data HEMTT parses SQF with, so it cannot appear in the source yet; compiled here
GVAR(webAction) = compile "(_this select 0) ctrlWebBrowserAction (_this select 1)";

// Compiled app/page scripts by path (see fnc_compileScript)
GVAR(scriptCache) = createHashMap;
