#include "script_component.hpp"

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

// labels and links of the debug overlay (common setting "Debug overlay"): ITC guns, the FDC and their fire data
if (hasInterface) then {
    [
        QUOTE(ADDON),
        {
            params ["_object"];
            [_object] call FUNC(getGunBatteryType) != ""
                || {_object isEqualTo ACE_player && {(missionNamespace getVariable [QEGVAR(tablet,bcs_bty_guns), []]) isNotEqualTo []}}
        },
        LINKFUNC(debugLines),
        LINKFUNC(debugDrawLinks)
    ] call EFUNC(common,registerDebug);
};
