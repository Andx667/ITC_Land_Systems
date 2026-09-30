#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Per-frame check for sight overlays: hides the overlay's control group while the camera is not
 * in gunner view, and hides it and removes the calling per-frame handler once the player no
 * longer holds the required role.
 *
 * Arguments:
 * 0: Sight display <DISPLAY>
 * 1: IDC of the overlay's control group <NUMBER>
 * 2: Per-frame handler ID to remove when the role is lost <NUMBER>
 * 3: The player's current role <STRING>
 * 4: The role required to keep the overlay running <STRING>
 *
 * Return Value:
 * True if the overlay should be updated this frame <BOOL>
 *
 * Example:
 * [_display, 81001, _pfID, ACE_player call CBA_fnc_vehicleRole, "GUNNER"] call itc_land_common_fnc_sightViewCheck
 *
 * Public: No
 */

params ["_display", "_groupIdc", "_pfID", "_role", "_requiredRole"];

private _group = _display displayCtrl _groupIdc;

if (cameraView != "GUNNER" || {_role != _requiredRole}) exitWith {
    _group ctrlShow false;
    if (_role != _requiredRole) then {
        [_pfID] call CBA_fnc_removePerFrameHandler;
    };
    false
};

_group ctrlShow true;
true
