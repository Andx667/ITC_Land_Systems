#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Handles the native "Fired" event, filtering for AMOS mortar shell (direct and
 * guided) ammo types; when a matching round is fired, adds the projectile to
 * the tracked list of active COBRA counter-battery shells for later scan,
 * impact and origin processing.
 *
 * Arguments:
 * 0: Unit that fired (unused) <Object>
 * 1: Weapon fired (unused) <String>
 * 2: Muzzle used (unused) <String>
 * 3: Fire mode used (unused) <String>
 * 4: Ammo class fired <String>
 * 5: Magazine used (unused) <String>
 * 6: Projectile object <Object>
 * 7: Gunner of the vehicle (unused) <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_cobra_fnc_fired
 *
 * Public: No
 */

//if (!isServer) exitWith {};

params ["", "", "", "", "_ammo", "", "_projectile", "_gunner"];

if(_ammo isKindOf ["Sh_155mm_AMOS", configFile >> "cfgAmmo"] || _ammo isKindOf ["Sh_82mm_AMOS_guided", configFile >> "cfgAmmo"]) exitWith {
    //{
    //  (_x getVariable "shells") pushBack _projectile;
    //}forEach itc_land_cobras;
    itc_land_cobra_shells pushBack _projectile;
};
