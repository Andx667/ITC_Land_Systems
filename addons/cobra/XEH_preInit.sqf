#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

#include "initSettings.inc.sqf"

call FUNC(init);

// labels and detections of the debug overlay (common setting "Debug overlay")
if (hasInterface) then {
    [
        QUOTE(ADDON),
        {(_this # 0) in GVAR(vehicles)},
        LINKFUNC(debugLines),
        LINKFUNC(debugDrawDetections)
    ] call EFUNC(common,registerDebug);
};
