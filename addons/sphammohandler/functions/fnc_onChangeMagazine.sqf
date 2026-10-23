#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Handles the changeMagazine event on the machine where the SPH's main turret is local
 * and applies the requested magazine change to that turret.
 *
 * Arguments:
 * 0: SPH vehicle <OBJECT>
 * 1: Action: "remove", "add", "closeBreech" or "drop" (chamber and fire a mortar round) <STRING>
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
    case "drop": {
        // A mortar round fires as it slides onto the firing pin: chamber it, then the gunner fires
        // once the gun has taken it. Should that not happen, the round stays in for the trigger.
        [_vehicle, "closeBreech", _magClass] call FUNC(onChangeMagazine);
        private _weapon = (_vehicle weaponsTurret [0]) param [0, ""];
        [{
            params ["_vehicle", "_weapon"];
            (weaponState [_vehicle, [0], _weapon]) params ["", "", "", "_magazine", "", "_roundPhase", "_magazinePhase"];
            _magazine != "" && {_roundPhase == 0} && {_magazinePhase == 0}
        }, {
            params ["_vehicle", "_weapon"];
            (gunner _vehicle) forceWeaponFire [_weapon, (getArray (configFile >> "CfgWeapons" >> _weapon >> "modes")) param [0, "this"]];
        }, [_vehicle, _weapon], 5, {
            params ["_vehicle"];
            _vehicle setVariable ["itc_land_ammoHandler_status", [2, 6, LSTRING(Status_Misfire)], true];
            [] call FUNC(updateStatus);
        }] call CBA_fnc_waitUntilAndExecute;
    };
};
