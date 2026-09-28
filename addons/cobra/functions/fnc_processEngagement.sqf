#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Groups detected firing origins into named "engagements" - clusters of shots
 * within 300m of each other fired within the configured engagement-time
 * window - updating the shot count and timestamps for an existing engagement,
 * or creating a new one with an auto-incrementing "CBxxxx" identifier if none
 * of the recent engagements are close enough.
 *
 * Arguments:
 * 0: COBRA radar vehicle processing the engagement (unused in body) <Object>
 * 1: Detected firing-origin position to associate with an engagement <Position>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_cbr, _origin] call itc_land_cobra_fnc_processEngagement
 *
 * Public: No
 */

params ["_cbr", "_origin"];
private _engagements = missionNamespace getVariable "itc_land_cobra_engagements";
private _existingPosition = nil;
{
    _x params ["_ident","_shots", "_positions", "_firstShot", "_lastShot"];
    for "_i" from 0 to (count _positions) - 1 step 1 do {
        if(_origin distance (_positions # _i) < 300 && (_lastShot + (missionNamespace getVariable "itc_land_cobra_engagementTime")) > time) then {
            if(isNil{_existingPosition}) then {
                _existingPosition = _x;
                _positions pushBack _origin;
                _x set [1,_shots + 1];
                _x set [4, time];
                _x set [5, dayTime]
            };
        };
    };
}forEach _engagements;

if(isNil{_existingPosition}) then {
    private _start = missionNamespace getVariable "itc_land_cobra_start";
    _engagements pushBack [format["CB%1",[_start,4] call cba_fnc_formatNumber],1, [_origin], time, time, dayTime];
    missionNamespace setVariable ["itc_land_cobra_start", _start + 1];
};
missionNamespace setVariable ["itc_land_cobra_engagements",_engagements];
