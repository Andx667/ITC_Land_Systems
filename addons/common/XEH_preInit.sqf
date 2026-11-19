#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Systems of the debug overlay, id -> [has the system, lines, extra drawing], see fnc_registerDebug
GVAR(debugProviders) = createHashMap;
// Draw3D handler of the debug overlay while it is on
GVAR(debugHandle) = -1;

#include "initSettings.inc.sqf"
