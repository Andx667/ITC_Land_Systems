#include "script_component.hpp"

[QGVAR(sirenPlay), FUNC(sirenPlay)] call CBA_fnc_addEventHandler;

if (isServer) then {
    [FUNC(scan), 1] call CBA_fnc_addPerFrameHandler;
};
