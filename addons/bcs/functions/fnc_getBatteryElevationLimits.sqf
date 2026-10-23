#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Gets the elevation limits of a BCS battery type, for guns the BCS knows no vehicle of (hand-
 * entered guns, the battery-centre solution): the battery type's elevationLimits[] in config, or
 * else the widest minElev/maxElev of the main turrets of all public vehicles carrying its weapon,
 * so only solutions no gun of that type can lay are dropped. Cached per battery type.
 *
 * Arguments:
 * 0: Battery type class name (itc_land_ballistics >> batteryTypes) <STRING>
 *
 * Return Value:
 * [min, max] in degrees, or [] if no limits are known <ARRAY>
 *
 * Example:
 * ["G155"] call itc_land_bcs_fnc_getBatteryElevationLimits
 *
 * Public: No
 */

params ["_batteryType"];

if (isNil QGVAR(elevationLimitsCache)) then {GVAR(elevationLimitsCache) = createHashMap};

GVAR(elevationLimitsCache) getOrDefaultCall [_batteryType, {
    private _config = configFile >> "itc_land_ballistics" >> "batteryTypes" >> _batteryType;
    private _limits = getArray (_config >> "elevationLimits");
    if (_limits isEqualTypeArray [0, 0]) exitWith {_limits};

    private _weapon = getText (_config >> "weaponClass");
    if (_weapon == "") exitWith {[]};
    private _min = 90;
    private _max = -90;
    {
        private _turrets = _x >> "Turrets";
        if (count _turrets > 0) then {
            private _turret = _turrets select 0;
            if (_weapon in getArray (_turret >> "weapons") && {isNumber (_turret >> "minElev")} && {isNumber (_turret >> "maxElev")}) then {
                _min = _min min getNumber (_turret >> "minElev");
                _max = _max max getNumber (_turret >> "maxElev");
            };
        };
    } forEach ("getNumber (_x >> 'scope') == 2 && {isClass (_x >> 'Turrets')}" configClasses (configFile >> "CfgVehicles"));

    if (_max < _min) then {[]} else {[_min, _max]}
}, true]
