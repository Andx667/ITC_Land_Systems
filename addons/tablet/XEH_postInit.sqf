#include "script_component.hpp"

if (hasInterface) then {
    // observers' targets reach every player from the start (and the new unit after a respawn)
    ["unit", {
        params ["_unit"];
        [_unit] call FUNC(bcsListenTargets);
    }, true] call CBA_fnc_addPlayerEventHandler;
};
