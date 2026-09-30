#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Runs code every frame (or every delay seconds) for as long as a projectile is alive, and
 * removes the per-frame handler once it is gone.
 *
 * Arguments:
 * 0: Projectile to follow <OBJECT>
 * 1: Code run while the projectile is alive, receives [projectile, args, per-frame handler ID] <CODE>
 * 2: Delay between runs in seconds (default: 0) <NUMBER>
 * 3: Arguments passed to the code; the array is shared between runs, so it can carry state (default: []) <ARRAY>
 * 4: Code run once when the projectile is gone, receives [projectile, args] (default: {}) <CODE>
 *
 * Return Value:
 * Per-frame handler ID <NUMBER>
 *
 * Example:
 * [_projectile, {params ["_projectile"]; systemChat str getPosASL _projectile}, 0.1] call itc_land_common_fnc_addProjectilePFH
 *
 * Public: No
 */

params ["_projectile", "_code", ["_delay", 0], ["_args", []], ["_onEnd", {}]];

[{
    (_this select 0) params ["_projectile", "_code", "_args", "_onEnd"];
    private _pfhId = _this select 1;

    if (!alive _projectile) exitWith {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
        [_projectile, _args] call _onEnd;
    };

    [_projectile, _args, _pfhId] call _code;
}, _delay, [_projectile, _code, _args, _onEnd]] call CBA_fnc_addPerFrameHandler
