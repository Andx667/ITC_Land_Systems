#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Fired EH for RHEA vehicles. Forwards the Fired event handler parameters
 * unchanged to test_fnc_fired for handling.
 *
 * Arguments:
 * 0: Vehicle/unit that fired the shot <OBJECT>
 * 1: Weapon fired <STRING>
 * 2: Muzzle used <STRING>
 * 3: Firing mode <STRING>
 * 4: Ammo classname fired <STRING>
 * 5: Magazine used <STRING>
 * 6: Fired projectile <OBJECT>
 * 7: Gunner of the firing vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_veh_rhea_fnc_fired
 *
 * Public: No
 */

_this call test_fnc_fired;
