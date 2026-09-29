#include "..\script_component.hpp"

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

//check gun status. if 3 (loaded and ready to fire), then unload, if 1 (empty and ready to load) then load, otherwise do nothing.
switch ( _loaderType ) do {
    case 0: {
        //Manual loading
    };
    case 1: {
        //Semi Automatic Loading
        switch ( _status ) do {
            case 3: {
                //systemChat "Remove loaded magazine.";
                [_vehicle,_curMag] spawn {
                    private _vehicle = _this select 0;
                    private _curMag = _this select 1;
                    private _loadedMagClass = _vehicle getVariable "itc_land_loadedMagClass";

                    disableSerialization;

                    _vehicle setVariable ["itc_land_ammoHandler_status",[4,0,"SAFING WEAPON"],true]; [] call FUNC(updateStatus);

                    sleep (3+random(2));
                    _vehicle setVariable ["itc_land_ammoHandler_status",[4,1,"REMOVING CHARGE"],true]; [] call FUNC(updateStatus);

                    sleep (2+random(1));
                    _vehicle setVariable ["itc_land_ammoHandler_status",[4,2,"REMOVING ROUND"],true]; [] call FUNC(updateStatus);

                    _vehicle removeMagazine _curMag; //remove loaded magazine

                    sleep (5+random(3));

                    _vehicle addMagazine _loadedMagClass;
                    _vehicle setVariable ["itc_land_ammoHandler_status",[4,3,"STOWING ROUND"],true]; [] call FUNC(updateStatus);

                    sleep (2+random(2));

                    _vehicle setVariable ["itc_land_ammoHandler_status",[1,0,"WAITING"],true]; [] call FUNC(updateStatus);
                };
            };
            case 1: {
                //systemChat "Load the magazine";
                [_vehicle] spawn {
                    disableSerialization;

                    private _vehicle = _this select 0;
                    private _currentMagInfo = _vehicle getVariable "itc_land_currentMagInfo";
                    _currentMagInfo params ["_selectedMagIndex","_selectedMagClass","_selectedMagConfig"];

                    //Get class of magazine to load
                    private _magFormat = getText (_selectedMagConfig >> "itc_land_charge_format");
                    private _magClass = format [ _magFormat , (_vehicle getVariable ["itc_land_currentChargeIndex",1]) ];
                    _vehicle setVariable ["itc_land_loadedMagClass",_selectedMagClass,true];

                    _vehicle removeMagazine (_vehicle getVariable "itc_land_loadedMagClass");
                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,0,"PULLING SHELL"],true]; [] call FUNC(updateStatus);
                    sleep (2+random(1));

                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,1,"RAMMING SHELL"],true]; [] call FUNC(updateStatus);

                    sleep (2+random(1));
                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,2,"INSERTING CHARGE"],true]; [] call FUNC(updateStatus);

                    sleep (2+random(1));

                    private _weapon = (weapons _vehicle) select 0;

                    _vehicle removeWeapon _weapon;
                    _vehicle addMagazine _magClass;
                    _vehicle addWeapon _weapon;
                    _vehicle selectWeapon _weapon;

                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,3,"CLOSING BREECH"],true]; [] call FUNC(updateStatus);

                    sleep (2+random(1));
                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,4,"INSERTING PRIMER"],true]; [] call FUNC(updateStatus);


                    sleep (2+random(1));
                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,5,"ATTACHING LANYARD"],true]; [] call FUNC(updateStatus);


                    sleep (1+random(1));
                    _vehicle setVariable ["itc_land_ammoHandler_status",[3,0,"READY TO FIRE"],true]; [] call FUNC(updateStatus);


                };
            };
            default {
                //systemChat "Shit aint working toad";
            };
        };
    };
    case 2: {
        switch ( _status ) do {
            case 3: {
                //systemChat "Remove loaded magazine.";
                [_vehicle,_curMag] spawn {
                    private _vehicle = _this select 0;
                    private _curMag = _this select 1;
                    private _loadedMagClass = _vehicle getVariable "itc_land_loadedMagClass";

                    disableSerialization;

                    _vehicle setVariable ["itc_land_ammoHandler_status",[4,0,"SAFING WEAPON"],true]; [] call FUNC(updateStatus);
                    sleep 1;
                    _vehicle setVariable ["itc_land_ammoHandler_status",[4,2,"REMOVING ROUND"],true]; [] call FUNC(updateStatus);
                    _vehicle removeMagazine _curMag; //remove loaded magazine

                    sleep 4;

                    _vehicle addMagazine _loadedMagClass;
                    _vehicle setVariable ["itc_land_ammoHandler_status",[4,3,"STOWING ROUND"],true]; [] call FUNC(updateStatus);

                    sleep 4;

                    _vehicle setVariable ["itc_land_ammoHandler_status",[1,0,"WAITING"],true]; [] call FUNC(updateStatus);
                };
            };
            case 1: {
                //systemChat "Load the magazine";
                [_vehicle] spawn {
                    disableSerialization;

                    private _vehicle = _this select 0;
                    private _currentMagInfo = _vehicle getVariable "itc_land_currentMagInfo";
                    _currentMagInfo params ["_selectedMagIndex","_selectedMagClass","_selectedMagConfig"];

                    //Get class of magazine to load
                    private _magFormat = getText (_selectedMagConfig >> "itc_land_charge_format");
                    private _magClass = format [ _magFormat , (_vehicle getVariable ["itc_land_currentChargeIndex",1]) ];
                    _vehicle setVariable ["itc_land_loadedMagClass",_selectedMagClass,true];

                    _vehicle removeMagazine (_vehicle getVariable "itc_land_loadedMagClass");
                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,0,"PULLING SHELL"],true]; [] call FUNC(updateStatus);
                    sleep 1;

                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,1,"RAMMING SHELL"],true]; [] call FUNC(updateStatus);

                    sleep 0.5;
                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,2,"INSERTING CHARGE"],true]; [] call FUNC(updateStatus);

                    sleep 0.5;
                    private _weapon = (weapons _vehicle) select 0;

                    _vehicle removeWeapon _weapon;
                    _vehicle addMagazine _magClass;
                    _vehicle addWeapon _weapon;
                    _vehicle selectWeapon _weapon;

                    _vehicle setVariable ["itc_land_ammoHandler_status",[2,3,"CLOSING BREECH"],true]; [] call FUNC(updateStatus);

                    sleep 3;
                    _vehicle setVariable ["itc_land_ammoHandler_status",[3,0,"READY TO FIRE"],true]; [] call FUNC(updateStatus);


                };
            };
            default {
                //systemChat "Shit aint working toad";
            };
        };
    };
};
