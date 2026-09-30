#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Starts the per-frame handler of an optics HUD (connected UAV or vehicle commander): view
 * direction in degrees and mils, grid and altitude of the point under the crosshair and of
 * the camera platform, the compass needle, and optionally the laser status. The HUD is hidden
 * and the handler removed once the player loses the required role.
 *
 * Arguments:
 * 0: Sight name, e.g. "RscOptics_UAV_gunner" <STRING>
 * 1: Layout <HASHMAP>
 *    "uav": true to follow the connected UAV, false to use the player's vehicle <BOOL>
 *    "role": role required to keep the HUD running <STRING>
 *    "dirDigits": integer places of the direction in degrees <NUMBER>
 *    "combined": show "grid / altitude" in one control instead of separate ones <BOOL>
 *    "laser": show the laser status and code <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["RscOptics_UAV_gunner", createHashMapFromArray [["uav", true], ["role", "GUNNER"], ["dirDigits", 3], ["combined", false], ["laser", false]]] call itc_land_veh_sights_fnc_runOptics
 *
 * Public: No
 */

params ["_sightName", "_layout"];

[{
    (_this select 0) params ["_displayVar", "_layout"];
    disableSerialization;
    private _display = uiNamespace getVariable [_displayVar, displayNull];
    if (isNull _display) exitWith {};

    private _useUav = _layout get "uav";
    private _role = if (_useUav) then {[ACE_player] call ace_common_fnc_getUavControlPosition} else {ACE_player call CBA_fnc_vehicleRole};
    private _viewOk = [_display, 75001, _this select 1, _role, _layout get "role"] call EFUNC(common,sightViewCheck);
    if (!_viewOk) exitWith {};

    private _platform = if (_useUav) then {getConnectedUAV ACE_player} else {vehicle ACE_player};

    // uses the camera position instead of the weapon direction, so it works on every platform
    ([] call ace_common_fnc_getTargetAzimuthAndInclination) params ["_viewDir"];
    private _degrees = [_viewDir, _layout get "dirDigits"] call CBA_fnc_formatNumber;
    private _mils = [_viewDir, 0, 4] call EFUNC(common,FormatAsMils);
    (_display displayCtrl 75013) ctrlSetText format ["%1 / %2", _degrees, _mils];

    private _targetPos = screenToWorld [0.5, 0.5];
    private _targetGrid = [_targetPos] call EFUNC(common,posToGrid);
    private _platformGrid = [position _platform] call EFUNC(common,posToGrid);
    private _platformAlt = [[_platform] call EFUNC(common,getAltitudeMSL), 0, 4] call EFUNC(common,FormatAsMeters);
    // terrain height is negative under water
    private _targetAlt = [(round ((AGLToASL _targetPos) select 2) + ace_common_mapAltitude) max 0, 0, 4] call EFUNC(common,FormatAsMeters);

    if (_layout get "combined") then {
        (_display displayCtrl 75015) ctrlSetText (_targetGrid + " / " + _targetAlt);
        (_display displayCtrl 75018) ctrlSetText (_platformGrid + " / " + _platformAlt);
    } else {
        (_display displayCtrl 75015) ctrlSetText _targetGrid;
        (_display displayCtrl 75018) ctrlSetText _platformGrid;
        (_display displayCtrl 75017) ctrlSetText _targetAlt;
        (_display displayCtrl 75011) ctrlSetText _platformAlt;
    };

    (_display displayCtrl 75020) ctrlSetAngle [_viewDir * -1, 0.5, 0.5];

    if (_layout get "laser") then {
        if (isLaserOn _platform) then {
            [_display, 75021, 0] call EFUNC(common,ctrlSetFade);
            private _laserCode = _platform getVariable ["ace_laser_code", 1111];
            (_display displayCtrl 75021) ctrlSetText ([_laserCode, 4, 0, false] call CBA_fnc_formatNumber);
        } else {
            [_display, 75021, 1] call EFUNC(common,ctrlSetFade);
        };
    };
}, 0, ["ITC_Land_" + _sightName, _layout]] call CBA_fnc_addPerFrameHandler;
