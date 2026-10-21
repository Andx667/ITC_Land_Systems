#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Compiled app/page scripts by path (see fnc_compileScript)
GVAR(scriptCache) = createHashMap;
