#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Handles the changeMagazine event on the machine where the SPH's main turret is local
 * and applies the requested magazine change to that turret.
 *
 * Arguments:
 * 0: SPH vehicle <OBJECT>
 * 1: Action: "remove", "add" or "closeBreech" <STRING>
 * 2: Magazine classname <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "remove", "itc_Sh_155mm_HE"] call itc_land_sphammohandler_fnc_onChangeMagazine
 *
 * Public: No
 */

params ["_vehicle", "_action", "_magClass"];

if !(_vehicle turretLocal [0]) exitWith {};

switch (_action) do {
    case "remove": {
        _vehicle removeMagazineTurret [_magClass, [0]];
    };
    case "add": {
        _vehicle addMagazineTurret [_magClass, [0]];
    };
    case "closeBreech": {
        // Re-adding the weapon is what makes it pick up the magazine as chambered
        // the gun of the main turret; weapons _vehicle can list hull weapons first (RHS M109 smoke generator)
        private _weapon = (_vehicle weaponsTurret [0]) param [0, ""];
        _vehicle removeWeaponTurret [_weapon, [0]];
        _vehicle addMagazineTurret [_magClass, [0]];
        _vehicle addWeaponTurret [_weapon, [0]];
        _vehicle selectWeaponTurret [_weapon, [0]];
    };
};
