#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Groups detected firing-origin positions into clusters (within 15m of each
 * other), incrementing the shot count and timestamp for an existing cluster,
 * or creating a new one if none of the tracked positions are close enough.
 * Also appends the raw origin to the mission's flat list of all origins.
 *
 * Arguments:
 * 0: COBRA radar vehicle processing the origin (unused in body) <Object>
 * 1: Detected firing-origin position <Position>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_cbr, _origin] call itc_land_cobra_fnc_processOrigin
 *
 * Public: No
 */

params ["_cbr", "_origin"];
private _origins = missionNamespace getVariable "itc_land_cobra_origins";
private _firingPositions = missionNamespace getVariable "itc_land_cobra_firingPositions";
_origins pushBack _origin;
private _existingPosition = nil;
{
    _x params ["_shots", "_positions"];
    for "_i" from 0 to (count _positions) - 1 step 1 do {
        if(_origin distance (_positions # _i) < 15) then {
            if(isNil{_existingPosition}) then {
                _existingPosition = _x;
                _positions pushBack _origin;
                _x set [0,_shots + 1];
                _x set [2, time];
            };
        };
    };
}forEach _firingPositions;

if(isNil{_existingPosition}) then {
    _firingPositions pushBack [1, [_origin], time];
};

missionNamespace setVariable ["itc_land_cobra_firingPositions",_firingPositions];
missionNamespace setVariable ["itc_land_cobra_origins",_origins];
