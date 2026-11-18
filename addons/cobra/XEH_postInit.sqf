#include "script_component.hpp"

[QGVAR(sirenPlay), FUNC(sirenPlay)] call CBA_fnc_addEventHandler;

if (isServer) then {
    // a joining client gets the whole state once, every change after that comes as its own event
    [QGVAR(requestState), {
        params ["_owner"];
        [QGVAR(state), [itc_land_cobras, GVAR(firingPositions), GVAR(engagements), GVAR(activeShells)], _owner] call CBA_fnc_ownerEvent;
    }] call CBA_fnc_addEventHandler;

    [FUNC(scan), 1] call CBA_fnc_addPerFrameHandler;
};

// clients keep a copy of the server's results for the tablet; the server's own copy is the original
if (hasInterface && {!isServer}) then {
    // changes can arrive before the answer to requestState; the state already holds them and replaces the copy
    [QGVAR(state), {
        params ["_cobras", "_firingPositions", "_engagements", "_activeShells"];
        itc_land_cobras = _cobras;
        GVAR(firingPositions) = _firingPositions;
        GVAR(engagements) = _engagements;
        GVAR(activeShells) = _activeShells;
    }] call CBA_fnc_addEventHandler;

    [QGVAR(cobrasChanged), {
        params ["_cobras"];
        itc_land_cobras = _cobras;
    }] call CBA_fnc_addEventHandler;

    [QGVAR(firingPositionChanged), {
        params ["_index", "_firingPosition"];
        GVAR(firingPositions) set [_index, _firingPosition];
    }] call CBA_fnc_addEventHandler;

    [QGVAR(engagementChanged), {
        params ["_index", "_engagement"];
        GVAR(engagements) set [_index, _engagement];
    }] call CBA_fnc_addEventHandler;

    // expired impacts are dropped here; the server drops its own in the scan
    [QGVAR(impactAdded), {
        params ["_impact"];
        GVAR(activeShells) = GVAR(activeShells) select {cba_missionTime <= _x # 1};
        GVAR(activeShells) pushBack _impact;
    }] call CBA_fnc_addEventHandler;

    [QGVAR(requestState), [clientOwner]] call CBA_fnc_serverEvent;
};
