#include "..\script_component.hpp"

// Sequence steps receive [_vehicle, ...] as _this
#define SET_STATUS(STAGE,STEP,TEXT) (_this select 0) setVariable ["itc_land_ammoHandler_status", [STAGE, STEP, TEXT], true]; [] call FUNC(updateStatus)

/*
 * Author: ITC Addons Team
 * Loads or unloads the SPH's gun magazine according to the vehicle's configured
 * loader type (manual, semi-automatic or automatic) and current autoloader status,
 * running the load/unload sequence asynchronously and updating the autoloader status
 * (and its displayed text) through each step, from pulling/ramming the shell and
 * inserting the charge to closing the breech, or from safing the weapon to removing
 * and stowing the round.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_sphammohandler_fnc_loadGun
 *
 * Public: No
 */

//private _vehicle = vehicle ace_player;
private _vehicle = [] call EFUNC(common,getCurVehicle);
private _status = (_vehicle getVariable ["itc_land_ammoHandler_status",[0,0,"WAITING"]]) # 0;

private _loaderType = getNumber (configOf _vehicle >> "itc_land" >> "loaderType");
private _sphloadersettings = _vehicle getVariable ["itc_land_sphloadersettings", []];
private _roundCount = ((_sphloadersettings # 0) # 3);
private _roundsFired = _vehicle getVariable ["itc_land_roundsFired",0];

private _curMag = (currentMagazine _vehicle);
 _vehicle getVariable ["itc_land_sphloadersettings", []];
if (_roundCount == _roundsFired) then { _vehicle setVariable ["itc_land_roundsFired",0,true] };

// Status 3 (loaded, ready to fire) unloads, status 1 (empty, ready to load) loads, anything else does nothing.
// Loader type 1 is semi-automatic, 2 automatic; 0 (manual) has no sequence.
if !(_loaderType in [1, 2] && {_status in [1, 3]}) exitWith {};
private _semiAuto = _loaderType == 1;

if (_status == 3) exitWith {
    private _steps = if (_semiAuto) then {[
        [0, {SET_STATUS(4,0,"SAFING WEAPON")}],
        [3 + random 2, {SET_STATUS(4,1,"REMOVING CHARGE")}],
        [2 + random 1, {params ["_vehicle", "_curMag"]; SET_STATUS(4,2,"REMOVING ROUND"); _vehicle removeMagazine _curMag}],
        [5 + random 3, {params ["_vehicle", "", "_loadedMagClass"]; _vehicle addMagazine _loadedMagClass; SET_STATUS(4,3,"STOWING ROUND")}],
        [2 + random 2, {SET_STATUS(1,0,"WAITING")}]
    ]} else {[
        [0, {SET_STATUS(4,0,"SAFING WEAPON")}],
        [1, {params ["_vehicle", "_curMag"]; SET_STATUS(4,2,"REMOVING ROUND"); _vehicle removeMagazine _curMag}],
        [4, {params ["_vehicle", "", "_loadedMagClass"]; _vehicle addMagazine _loadedMagClass; SET_STATUS(4,3,"STOWING ROUND")}],
        [4, {SET_STATUS(1,0,"WAITING")}]
    ]};
    [_steps, [_vehicle, _curMag, _vehicle getVariable "itc_land_loadedMagClass"]] call FUNC(runSequence);
};

(_vehicle getVariable "itc_land_currentMagInfo") params ["", "_selectedMagClass", "_selectedMagConfig"];
private _magClass = format [getText (_selectedMagConfig >> "itc_land_charge_format"), _vehicle getVariable ["itc_land_currentChargeIndex", 1]];
_vehicle setVariable ["itc_land_loadedMagClass", _selectedMagClass, true];
_vehicle removeMagazine _selectedMagClass;

private _closeBreech = {
    params ["_vehicle", "_magClass"];
    private _weapon = (weapons _vehicle) select 0;
    _vehicle removeWeapon _weapon;
    _vehicle addMagazine _magClass;
    _vehicle addWeapon _weapon;
    _vehicle selectWeapon _weapon;
    SET_STATUS(2,3,"CLOSING BREECH");
};

private _steps = if (_semiAuto) then {[
    [0, {SET_STATUS(2,0,"PULLING SHELL")}],
    [2 + random 1, {SET_STATUS(2,1,"RAMMING SHELL")}],
    [2 + random 1, {SET_STATUS(2,2,"INSERTING CHARGE")}],
    [2 + random 1, _closeBreech],
    [2 + random 1, {SET_STATUS(2,4,"INSERTING PRIMER")}],
    [2 + random 1, {SET_STATUS(2,5,"ATTACHING LANYARD")}],
    [1 + random 1, {SET_STATUS(3,0,"READY TO FIRE")}]
]} else {[
    [0, {SET_STATUS(2,0,"PULLING SHELL")}],
    [1, {SET_STATUS(2,1,"RAMMING SHELL")}],
    [0.5, {SET_STATUS(2,2,"INSERTING CHARGE")}],
    [0.5, _closeBreech],
    [3, {SET_STATUS(3,0,"READY TO FIRE")}]
]};
[_steps, [_vehicle, _magClass]] call FUNC(runSequence);
