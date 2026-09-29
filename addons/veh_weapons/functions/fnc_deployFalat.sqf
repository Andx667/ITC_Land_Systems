#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Deploys a single laser-guided submunition ("Falat") from a fired shell.
 * Spawns a placeholder cargo object that, after a short delay, becomes an
 * ITC_155Extra loitering submunition, searches for a matching laser spot, and
 * fires a simulated HEAT projectile at it, or triggers itself after a timeout
 * if no laser spot is ever found.
 *
 * Arguments:
 * 0: Index of the submunition being deployed, used to select its laser code <NUMBER>
 * 1: World position to spawn the submunition at <ARRAY>
 * 2: Velocity vector of the parent projectile at deployment <ARRAY>
 * 3: Pitch of the parent projectile at deployment <NUMBER>
 * 4: Bank of the parent projectile at deployment <NUMBER>
 * 5: Guidance info array: [[laserCode0, laserCode1], targetGrid, targetAlt] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1, position _projectile, velocity _projectile, _pitch, _bank, _guidanceInfo] call itc_land_veh_weapons_fnc_deployFalat
 *
 * Public: No
 */

params ["_subMunitionIndex", "_position", "_velocity", "_pitch", "_bank", "_guidanceInfo"];

private _laserCode = 1111;
if (_subMunitionIndex < 2) then {
  _laserCode = _guidanceInfo # 0 # _subMunitionIndex;
};

//player sideChat format ["%1 deployed", _subMunitionIndex];
private _spawnPosAdjustment = (vectorNormalized _velocity) vectorMultiply _subMunitionIndex;
private _extra = createVehicle ["Land_FoodContainer_01_F", _position vectorAdd _spawnPosAdjustment, [], 0, "FLY"];
//_extra = createVehicle ["Land_FoodContainer_01_F", _position, [], 0, "FLY"];
private _randomizedVelocity = _velocity vectorAdd [random 5, random 5, random 5];
_extra setVelocity _randomizedVelocity;

[{
  params ["_pfhValues","_pfhId"];
  _pfhValues params ["_projectile", "_firedTime", "_initialSpeed", "_laserCode"];
  //INITIAL DEPLOYMENT FLIGHT
  if(time > _firedTime + 4 && typeOf _projectile == "Land_FoodContainer_01_F") then { //OPEN THE PARACHUTE
    //systemChat "PARACHUTE DEPLOYED";
    private _extra = createVehicle ["ITC_155Extra", getPos _projectile, [], 0, "FLY"];
    _extra setVelocity (velocity _projectile);
    deleteVehicle _projectile;
    _projectile = _extra;
    _pfhValues set [0, _extra];
  };

  if(time > _firedTime + 8 && typeOf _projectile == "ITC_155Extra") then { //SEARCH FOR A TARGET
    private _projectilePosASL = getPosASL _projectile;
    private _spot = [_projectilePosASL, [0,0,-1], 90, 300, [1500, 1550], _laserCode] call ace_laser_fnc_seekerFindLaserSpot;
    if(!isNil{_spot select 0}) then {
      private _heat = createVehicle ["R_MRAAWS_HEAT_F", getPos _projectile, [], 0, "FLY"];
      [_heat, -90, 0] call BIS_fnc_setPitchBank;
      private _vectorToTank = (_projectilePosASL) vectorFromTo (_spot select 0);
      _heat setVelocity (_vectorToTank vectorMultiply 5000);

      deleteVehicle _projectile;
      [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
  };

  if(time > _firedTime + 180 && typeOf _projectile == "ITC_155Extra") then { //SEARCH FOR A TARGET
        private _heat = createVehicle ["R_MRAAWS_HEAT_F", getPos _projectile, [], 0, "FLY"];
        [_heat, -90, 0] call BIS_fnc_setPitchBank;
        triggerAmmo _heat;
        deleteVehicle _projectile;
  };

  if(!alive _projectile) exitWith {
    [_pfhId] call CBA_fnc_removePerFrameHandler;
  };
}, 0.5, [_extra, time, vectorNormalized _velocity, _laserCode]] call CBA_fnc_addPerFrameHandler;
