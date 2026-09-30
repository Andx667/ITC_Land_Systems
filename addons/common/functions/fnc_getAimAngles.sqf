#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Gets the gun's current azimuth and quadrant elevation in degrees. When the player's camera
 * is looking at something other than the ground (e.g. the sky), the shell will not follow the
 * gun, so the angles are derived from the camera direction instead.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Name of the animation source that carries the gun elevation (default: "mainGun") <STRING>
 *
 * Return Value:
 * [azimuth, quadrant] in degrees <ARRAY>
 *
 * Example:
 * [_vehicle, "tower_fake"] call itc_land_common_fnc_getAimAngles
 *
 * Public: No
 */

params ["_vehicle", ["_elevationSource", "mainGun"]];

private _weaponDirVector = _vehicle weaponDirection currentWeapon _vehicle;
private _weaponDir = (_weaponDirVector call CBA_fnc_vect2Polar) select 1;
private _weaponQuad = (_weaponDirVector call CBA_fnc_vect2Polar) select 2;

private _seekerPosASL = AGLToASL (positionCameraToWorld [0,0,0]);
private _seekerDir = _seekerPosASL vectorFromTo (AGLToASL (positionCameraToWorld [0,0,1]));
private _testPoint = _seekerPosASL vectorAdd (_seekerDir vectorMultiply viewDistance);

if ((terrainIntersectASL [_seekerPosASL, _testPoint]) || {lineIntersects [_seekerPosASL, _testPoint]}) then {
    private _lookVector = ((positionCameraToWorld [0,0,0]) call ace_common_fnc_positionToASL) vectorFromTo ((positionCameraToWorld [0,0,10]) call ace_common_fnc_positionToASL);
    _weaponDir = (_lookVector select 0) atan2 (_lookVector select 1);
    private _upVectorDir = ((vectorUp _vehicle) select 0) atan2 ((vectorUp _vehicle) select 1);
    private _elevationDiff = (cos (_weaponDir - _upVectorDir)) * acos ((vectorUp _vehicle) select 2);
    _weaponQuad = ((180 / pi) * (_vehicle animationPhase _elevationSource)) - _elevationDiff;
    if (_weaponDir <= 0) then {_weaponDir = _weaponDir + 360};
};

[_weaponDir, _weaponQuad]
