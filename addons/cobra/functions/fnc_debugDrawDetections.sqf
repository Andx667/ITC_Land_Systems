#include "..\script_component.hpp"

/*
 * Author: Andx
 * Extra drawing of the debug overlay (common_fnc_registerDebug) for COBRA: the edges of the scan arc of every radar
 * near the camera, out to its range, and within DEBUG_POINT_DISTANCE of the camera the predicted impacts (with the
 * seconds to impact), the back-traced firing positions and the engagements they belong to.
 *
 * Arguments:
 * 0: Objects near the camera <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_objects] call itc_land_cobra_fnc_debugDrawDetections
 *
 * Public: No
 */

params [["_objects", [], [[]]]];

{
    private _origin = _x modelToWorldVisual [0, 0, 3];
    private _facing = DEBUG_FACING(_x);
    private _color = [[1, 0.6, 0.2, 0.6], [0.3, 1, 0.3, 0.6]] select (vectorMagnitude (velocity _x) < 1);

    {
        private _angle = _facing + _x;
        drawLine3D [_origin, _origin vectorAdd [GVAR(range) * sin _angle, GVAR(range) * cos _angle, 0], _color];
    } forEach [-DEBUG_ARC, DEBUG_ARC];
} forEach (_objects select {_x in GVAR(vehicles)});

private _eye = positionCameraToWorld [0, 0, 0];

{
    _x params ["_position", "_impactTime"];
    private _point = ASLToAGL _position;
    if (CBA_missionTime <= _impactTime && {_eye distance _point < DEBUG_POINT_DISTANCE}) then {
        [_point vectorAdd [0, 0, 2], format ["IMPACT in %1 s", round (_impactTime - CBA_missionTime)], [1, 0.2, 0.2, 1]] call EFUNC(common,debugText);
    };
} forEach GVAR(activeShells);

{
    _x params ["_shots", "_positions", "_lastShot"];
    private _point = ASLToAGL (_positions # 0);
    if (_eye distance _point < DEBUG_POINT_DISTANCE) then {
        [_point vectorAdd [0, 0, 2], format ["FIRING POSITION | %1 shots | last %2 s ago", _shots, round (CBA_missionTime - _lastShot)], [1, 0.2, 1, 1]] call EFUNC(common,debugText);
    };
} forEach GVAR(firingPositions);

{
    _x params ["_ident", "_shots", "_positions"];
    private _point = ASLToAGL (_positions # 0);
    if (_eye distance _point < DEBUG_POINT_DISTANCE) then {
        [_point vectorAdd [0, 0, 3], format ["ENGAGEMENT %1 | %2 shots", _ident, _shots], [1, 0.2, 1, 1]] call EFUNC(common,debugText);
    };
} forEach GVAR(engagements);
