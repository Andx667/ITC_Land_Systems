#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * "Fired" event handler for the SPH gun. Removes the fired magazine, increments the
 * vehicle's fired-round counter, and either starts loading the next round or updates
 * the autoloader status, depending on whether the ammo requested by the applied
 * loader settings is still available and the round-count limit has not been reached.
 *
 * Arguments:
 * 0: Unit or vehicle that fired the weapon <Object>
 * 1: Fired weapon classname <String>
 * 2: Fired muzzle classname <String>
 * 3: Fired weapon mode <String>
 * 4: Fired ammo classname <String>
 * 5: Fired magazine classname <String>
 * 6: Projectile object <Object>
 * 7: Unit that pulled the trigger <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_gun, _weapon, _muzzle, _mode, _ammo, _magazine, _shell, _gunner] call itc_land_sphammohandler_fnc_firedEH
 *
 * Public: No
 */


params ["_gun", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_shell", "_gunner"];

if (!(local _gunner)) exitWith {};

_gun removeMagazine _magazine;
private _gunMags = magazines _gun;

private _roundsFired = _gun getVariable ["itc_land_roundsFired",0];
_roundsFired = _roundsFired +1;
_gun setVariable ["itc_land_roundsFired",_roundsFired,true];

_gun setVariable ["itc_land_ammoHandler_status",[1,0,"WAITING"],true];
 [] call FUNC(updateStatus);

private _sphloadersettings = _gun getVariable ["itc_land_sphloadersettings", []];
private _ammoToLoad = ((_sphloadersettings # 0) # 1);
private _roundCount = ((_sphloadersettings # 0) # 3);

if ((_ammoToLoad in _gunMags) && {(_roundCount < 1) || ((_roundCount >= 1) && (_roundsFired < _roundCount))}) then {
    [] call FUNC(loadGun);
} else {
    if (_ammoToLoad in _gunMags) then {
        _gun setVariable ["itc_land_ammoHandler_status",[1,0,"WAITING"],true];
        [] call FUNC(updateStatus);
    } else {
        _gun setVariable ["itc_land_ammoHandler_status",[0,0,"WAITING"],true];
        [] call FUNC(updateStatus);
    };
};
