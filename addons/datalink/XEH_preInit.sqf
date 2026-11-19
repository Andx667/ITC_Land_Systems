#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

call FUNC(init);
call FUNC(serverInit);

// labels of the debug overlay (common setting "Debug overlay"): the datalink IDs of objects and their crews
if (hasInterface) then {
    [
        QUOTE(ADDON),
        {
            params ["_object"];
            (crew _object + [_object]) findIf {(_x getVariable [QGVAR(id), ""]) != ""} != -1
        },
        LINKFUNC(debugLines)
    ] call EFUNC(common,registerDebug);
};
