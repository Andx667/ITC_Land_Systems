#include "..\script_component.hpp"

// Sequence steps receive [_vehicle, ...] as _this
#define SET_STATUS(STAGE,STEP,TEXT) (_this select 0) setVariable ["itc_land_ammoHandler_status", [STAGE, STEP, TEXT], true]; [] call FUNC(updateStatus)

/*
 * Author: ITC Addons Team
 * Loads or unloads the SPH's gun magazine according to the vehicle's configured
 * loader type (manual, semi-automatic, automatic or muzzle loaded) and current autoloader status,
 * running the load/unload sequence asynchronously and updating the autoloader status
 * (and its displayed text) through each step, from pulling/ramming the shell and
 * inserting the charge to closing the breech, or from safing the weapon to removing
 * and stowing the round.
 * A muzzle-loaded mortar (loader type 3) has no breech: LOAD prepares a round (fuze and charge set,
 * held by the loader, not yet in the tube), then FIRE hangs and drops it and the gun fires by
 * itself; a prepared round can be stowed again. Preparing is slower without a loader in the
 * loader seat, and waits while the tube is too hot (see tubeHeat).
 *
 * Arguments:
 * 0: Vehicle <OBJECT> (default: the player's current vehicle)
 * 1: Stow the prepared round instead of firing it (mortar only) <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle] call itc_land_sphammohandler_fnc_loadGun
 *
 * Public: No
 */

params [["_vehicle", objNull, [objNull]], ["_stow", false, [false]]];
// The fired EH runs where the gunner is local, which is not the player's machine with an AI gunner
if (isNull _vehicle) then {
    _vehicle = [] call EFUNC(common,getCurVehicle);
};
private _status = (_vehicle getVariable ["itc_land_ammoHandler_status",[0,0,LSTRING(Status_Waiting)]]) # 0;

private _loaderType = getNumber (configOf _vehicle >> "itc_land" >> "loaderType");
// Loading always uses the applied settings, not whatever is currently selected in the dialog
private _sphloadersettings = _vehicle getVariable ["itc_land_sphloadersettings", []];

// Status 3 (loaded, ready to fire) unloads, status 1 (empty, ready to load) loads, anything else does nothing.
// Loader type 1 is semi-automatic, 2 automatic, 3 a muzzle-loaded mortar; 0 (manual) has no sequence.
if !(_loaderType in [1, 2, 3] && {_status in [1, 3]}) exitWith {};
if (_sphloadersettings isEqualTo []) exitWith {};
private _semiAuto = _loaderType == 1;

private _roundCount = (_sphloadersettings # 0) # 3;
if (_roundCount == _vehicle getVariable ["itc_land_roundsFired", 0]) then {
    _vehicle setVariable ["itc_land_roundsFired", 0, true];
};

if (_loaderType == 3) exitWith {
    if (_status == 3) exitWith {
        // the prepared round is in the loader's hands, the tube is empty
        if (_stow) exitWith {
            [[
                [0, {params ["_vehicle"]; [_vehicle, "add", _vehicle getVariable "itc_land_loadedMagClass"] call FUNC(changeMagazine); SET_STATUS(4,3,LSTRING(Status_StowingRound))}],
                [2 + random 1, {SET_STATUS(1,0,LSTRING(Status_Waiting))}]
            ], [_vehicle]] call FUNC(runSequence);
        };
        // the gunner's machine fires the gun (see onChangeMagazine)
        if (isNull gunner _vehicle) exitWith {
            [LLSTRING(NoGunner)] call ace_common_fnc_displayTextStructured;
        };
        [[
            [0, {SET_STATUS(2,4,LSTRING(Status_HangingRound))}],
            [0.7 + random 0.5, {
                params ["_vehicle"];
                [_vehicle, "drop", _vehicle getVariable "itc_land_preparedMagClass"] call FUNC(changeMagazine);
                SET_STATUS(2,5,LSTRING(Status_RoundAway));
            }]
        ], [_vehicle]] call FUNC(runSequence);
    };

    (_sphloadersettings # 0) params ["", "_selectedMagClass", "_charge"];
    _vehicle setVariable ["itc_land_loadedMagClass", _selectedMagClass, true];
    _vehicle setVariable ["itc_land_preparedMagClass", format [getText (configFile >> "CfgMagazines" >> _selectedMagClass >> "itc_land_charge_format"), _charge], true];
    [_vehicle, "remove", _selectedMagClass] call FUNC(changeMagazine);

    // one hand short without a loader; a hot tube has to cool to the sustained rate first
    private _pace = [1.5, 1] select (alive ([_vehicle] call FUNC(getLoader)));
    private _coolWait = [_vehicle] call FUNC(tubeHeat);

    private _steps = [
        [0, {SET_STATUS(2,0,LSTRING(Status_PreparingRound))}],
        [(1 + random 1) * _pace, {SET_STATUS(2,3,LSTRING(Status_SettingFuze))}],
        [(1.5 + random 1) * _pace, {SET_STATUS(3,0,LSTRING(Status_RoundPrepared))}]
    ];
    if (_coolWait > 0) then {
        _steps = [[0, {SET_STATUS(2,0,LSTRING(Status_TubeCooling))}], [_coolWait, {SET_STATUS(2,0,LSTRING(Status_PreparingRound))}]] + (_steps select [1]);
    };
    [_steps, [_vehicle]] call FUNC(runSequence);
};

private _curMag = currentMagazine _vehicle;

if (_status == 3) exitWith {
    private _steps = if (_semiAuto) then {[
        [0, {SET_STATUS(4,0,LSTRING(Status_SafingWeapon))}],
        [3 + random 2, {SET_STATUS(4,1,LSTRING(Status_RemovingCharge))}],
        [2 + random 1, {params ["_vehicle", "_curMag"]; SET_STATUS(4,2,LSTRING(Status_RemovingRound)); [_vehicle, "remove", _curMag] call FUNC(changeMagazine)}],
        [5 + random 3, {params ["_vehicle", "", "_loadedMagClass"]; [_vehicle, "add", _loadedMagClass] call FUNC(changeMagazine); SET_STATUS(4,3,LSTRING(Status_StowingRound))}],
        [2 + random 2, {SET_STATUS(1,0,LSTRING(Status_Waiting))}]
    ]} else {[
        [0, {SET_STATUS(4,0,LSTRING(Status_SafingWeapon))}],
        [1, {params ["_vehicle", "_curMag"]; SET_STATUS(4,2,LSTRING(Status_RemovingRound)); [_vehicle, "remove", _curMag] call FUNC(changeMagazine)}],
        [4, {params ["_vehicle", "", "_loadedMagClass"]; [_vehicle, "add", _loadedMagClass] call FUNC(changeMagazine); SET_STATUS(4,3,LSTRING(Status_StowingRound))}],
        [4, {SET_STATUS(1,0,LSTRING(Status_Waiting))}]
    ]};
    [_steps, [_vehicle, _curMag, _vehicle getVariable "itc_land_loadedMagClass"]] call FUNC(runSequence);
};

(_sphloadersettings # 0) params ["", "_selectedMagClass", "_charge"];
private _magClass = format [getText (configFile >> "CfgMagazines" >> _selectedMagClass >> "itc_land_charge_format"), _charge];
_vehicle setVariable ["itc_land_loadedMagClass", _selectedMagClass, true];
[_vehicle, "remove", _selectedMagClass] call FUNC(changeMagazine);

private _closeBreech = {
    params ["_vehicle", "_magClass"];
    [_vehicle, "closeBreech", _magClass] call FUNC(changeMagazine);
    SET_STATUS(2,3,LSTRING(Status_ClosingBreech));
};

private _steps = if (_semiAuto) then {[
    [0, {SET_STATUS(2,0,LSTRING(Status_PullingShell))}],
    [2 + random 1, {SET_STATUS(2,1,LSTRING(Status_RammingShell))}],
    [2 + random 1, {SET_STATUS(2,2,LSTRING(Status_InsertingCharge))}],
    [2 + random 1, _closeBreech],
    [2 + random 1, {SET_STATUS(2,4,LSTRING(Status_InsertingPrimer))}],
    [2 + random 1, {SET_STATUS(2,5,LSTRING(Status_AttachingLanyard))}],
    [1 + random 1, {SET_STATUS(3,0,LSTRING(Status_ReadyToFire))}]
]} else {[
    [0, {SET_STATUS(2,0,LSTRING(Status_PullingShell))}],
    [1, {SET_STATUS(2,1,LSTRING(Status_RammingShell))}],
    [0.5, {SET_STATUS(2,2,LSTRING(Status_InsertingCharge))}],
    [0.5, _closeBreech],
    [3, {SET_STATUS(3,0,LSTRING(Status_ReadyToFire))}]
]};
[_steps, [_vehicle, _magClass]] call FUNC(runSequence);
