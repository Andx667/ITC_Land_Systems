#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// Compiled ballistic tables by file path, filled on first use (see fnc_calcShellTypeSolutions)
GVAR(tableCache) = createHashMap;
