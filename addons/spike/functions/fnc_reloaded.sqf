#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Matches Arma's native "Reloaded" event-handler signature (unit, weapon,
 * muzzle, new magazine, old magazine), but is not currently registered via any
 * addEventHandler/CBA_fnc_addClassEventHandler call anywhere in the codebase.
 * As written the function takes no action - its only statement is a
 * commented-out debug systemChat.
 *
 * Arguments:
 * 0: Unit that reloaded <Object>
 * 1: Weapon that was reloaded <String>
 * 2: Muzzle that was reloaded <String>
 * 3: New magazine loaded <String>
 * 4: Old magazine that was unloaded <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, _weapon, _muzzle, _newMagazine, _oldMagazine] call itc_land_spike_fnc_reloaded
 *
 * Public: No
 */

params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];
//systemChat str _this;
