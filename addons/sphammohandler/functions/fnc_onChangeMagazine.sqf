#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Handles the changeMagazine event on the machine that owns the SPH vehicle and
 * applies the requested magazine change.
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

if (!local _vehicle) exitWith {};

switch (_action) do {
    case "remove": {
        _vehicle removeMagazine _magClass;
    };
    case "add": {
        _vehicle addMagazine _magClass;
    };
    case "closeBreech": {
        // Re-adding the weapon is what makes it pick up the magazine as chambered
        private _weapon = (weapons _vehicle) select 0;
        _vehicle removeWeapon _weapon;
        _vehicle addMagazine _magClass;
        _vehicle addWeapon _weapon;
        _vehicle selectWeapon _weapon;
    };
};
