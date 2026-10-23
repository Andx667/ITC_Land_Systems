#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The number for the next gun of the BCS battery: the lowest free one from 1 up, so linked and
 * hand-entered guns are numbered 1, 2, 3, ... and a removed gun's number is used again.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Gun number <STRING>
 *
 * Example:
 * [] call itc_land_tablet_fnc_bcsNextGunNumber
 *
 * Public: No
 */

private _taken = GVAR(bcs_bty_guns) apply {_x # 0};
private _number = 1;
while {str _number in _taken} do {_number = _number + 1};
str _number
