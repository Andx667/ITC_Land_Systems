#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Updates the guns linked in Battery Setup from their vehicles: grid, position, elevation and
 * direction as they are now. Hand-entered guns and linked guns that are destroyed or gone keep
 * their last data.
 *
 * Arguments:
 * 0: Guns in the battery <ARRAY> of [gun number <STRING>, grid <STRING>, position ASL <ARRAY>,
 *    elevation <NUMBER>, direction (degrees) <NUMBER>, battery name <STRING>, linked vehicle <OBJECT> (optional)]
 *
 * Return Value:
 * The guns, the linked ones updated <ARRAY>
 *
 * Example:
 * [itc_land_tablet_bcs_bty_guns] call itc_land_bcs_fnc_refreshLinkedGuns
 *
 * Public: No
 */

params ["_guns"];

_guns apply {
    _x params ["_num", "", "", "", "", "_batteryName", ["_vehicle", objNull]];
    if (!alive _vehicle) then {
        _x
    } else {
        private _pos = getPosASL _vehicle;
        [_num, [_pos] call EFUNC(common,posToGrid), _pos, round (_pos # 2), getDir _vehicle, _batteryName, _vehicle]
    };
}
