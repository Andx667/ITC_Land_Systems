#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Gets the main gun's barrel from the main turret's muzzle and breech memory points (gunBeg and
 * gunEnd): the breech position, taken as the point the barrel elevates about, and the barrel
 * length. Firing solutions start the trajectory at the muzzle, which for a given lay is the
 * breech plus the barrel length along azimuth and quadrant. The breech stands in for the
 * trunnion, which models do not mark; the difference is a fraction of a metre.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * [breech position ASL <ARRAY>, barrel length in metres <NUMBER>], or [] without both memory points <ARRAY>
 *
 * Example:
 * [vehicle player] call itc_land_common_fnc_getBarrel
 *
 * Public: No
 */

params ["_vehicle"];

private _turretConfig = [_vehicle, [0]] call BIS_fnc_turretConfig;
private _muzzleName = getText (_turretConfig >> "gunBeg");
private _breechName = getText (_turretConfig >> "gunEnd");
if (_muzzleName == "" || {_breechName == ""}) exitWith {[]};

private _muzzle = _vehicle selectionPosition [_muzzleName, "Memory"];
private _breech = _vehicle selectionPosition [_breechName, "Memory"];
private _length = _muzzle distance _breech;
// a missing memory point reads as the model origin
if (_length < 0.5 || {_muzzle isEqualTo [0, 0, 0]} || {_breech isEqualTo [0, 0, 0]}) exitWith {[]};

[_vehicle modelToWorldWorld _breech, _length]
