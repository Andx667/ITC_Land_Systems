#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Server-side once-per-second scan over all COBRA radar vehicles: drops
 * destroyed COBRAs, then checks each tracked indirect-fire shell against every
 * stationary COBRA's turret arc, detection range and terrain line-of-sight.
 * The first COBRA that detects a shell calculates its impact and origin
 * points and records the impact, origin and engagement; the shell then stops
 * being tracked (as does any shell that is no longer alive). Also purges
 * expired impact predictions. The process functions send each new result to
 * the clients as an event; a destroyed COBRA sends cobrasChanged.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_cobra_fnc_scan
 *
 * Public: No
 */

private _cobras = GVAR(vehicles) select {alive _x};
if (count _cobras != count GVAR(vehicles)) then {
    GVAR(vehicles) = _cobras;
    [QGVAR(cobrasChanged), [_cobras]] call CBA_fnc_globalEvent;
};

private _scanning = _cobras select {vectorMagnitude (velocity _x) < 1};
private _remainingShells = [];
{
    private _shell = _x;
    if (alive _shell) then {
        private _detectedBy = _scanning findIf {
            private _dir = deg (_x animationPhase "mainTurret");
            _dir = (getDir _x - _dir);
            if (_dir > 360) then {_dir = _dir - 360;};
            private _angleTo = abs (((_dir) + 360) - ((_x getDir _shell) + 360));
            _angleTo < 23
                && {_shell distance _x < GVAR(range)}
                && {!(terrainIntersectASL [getPosASL _shell, (getPosASL _x) vectorAdd [0,0,3]])}
        };
        if (_detectedBy == -1) then {
            _remainingShells pushBack _shell;
        } else {
            private _cbr = _scanning select _detectedBy;
            private _impact = [_shell] call EFUNC(common,simulateTrajectory);
            [_cbr, _impact] call FUNC(processImpact);
            private _origin = ([_shell, true] call EFUNC(common,simulateTrajectory)) # 0;
            [_cbr, _origin] call FUNC(processOrigin);
            [_cbr, _origin] call FUNC(processEngagement);
        };
    };
} forEach GVAR(shells);
GVAR(shells) = _remainingShells;

// clients drop expired impacts themselves (cobra XEH_postInit), so this needs no event
GVAR(activeShells) = GVAR(activeShells) select {cba_missionTime <= _x # 1};
