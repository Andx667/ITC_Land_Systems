#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Deploys a single unguided submunition ("Extra") from a fired 155mm Mof35 shell.
 * Spawns a placeholder cargo object that, after a short delay, becomes an
 * ITC_155Extra loitering submunition, searches nearby armored targets, and fires
 * a simulated HEAT projectile at the first target found within range, or
 * self-destructs if it descends below a minimum altitude.
 *
 * Arguments:
 * 0: Index of the submunition being deployed, used to offset its spawn position <NUMBER>
 * 1: World position to spawn the submunition at <ARRAY>
 * 2: Velocity vector of the parent projectile at deployment <ARRAY>
 * 3: Pitch of the parent projectile at deployment <NUMBER>
 * 4: Bank of the parent projectile at deployment <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1, position _projectile, velocity _projectile, _pitch, _bank] call itc_land_veh_weapons_fnc_deployExtra
 *
 * Public: No
 */

params ["_subMunitionIndex", "_position", "_velocity", "_pitch", "_bank"];
//player sideChat format ["%1 deployed", _subMunitionIndex];
private _spawnPosAdjustment = (vectorNormalized _velocity) vectorMultiply _subMunitionIndex;
private _extra = createVehicle ["Land_FoodContainer_01_F", _position vectorAdd _spawnPosAdjustment, [], 0, "FLY"];
//_extra = createVehicle ["Land_FoodContainer_01_F", _position, [], 0, "FLY"];
private _randomizedVelocity = _velocity vectorAdd [random 3, random 3, random 3];
_extra setVelocity _randomizedVelocity;

[{
  params ["_pfhValues","_pfhId"];
  _pfhValues params ["_projectile", "_firedTime", "_initialSpeed"];
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
    private _tanks = nearestObjects [[getPos _projectile # 0, getPos _projectile # 1, 0], ["Wheeled_APC_F","Tank_F"], 50];
    //systemChat str _tanks;

    private _selectTankIndex = _tanks findIf {(alive _x && _x distance _projectile < 75)};
    //systemChat str _selectTankIndex;

    if(_selectTankIndex != -1) then {
      private _selectTank = _tanks # _selectTankIndex;

    //  systemChat format ["TARGET FOUND: %1",_selectTank];

      private _heat = createVehicle ["R_MRAAWS_HEAT_F", getPos _projectile, [], 0, "FLY"];
      [_heat, -90, 0] call BIS_fnc_setPitchBank;
      private _vectorToTank = (getPos _projectile) vectorFromTo ((getPos _selectTank) vectorAdd [0,0,1]);
      _heat setVelocity (_vectorToTank vectorMultiply 5000);

      //systemChat str _vectorToTank;

      deleteVehicle _projectile;
      [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
  };

  if(getPosATL _projectile # 2 < 20 || getPosASL _projectile # 2 < 15) exitWith {
    //systemChat "SELF DESTRUCT";
    private _heat = createVehicle ["R_MRAAWS_HEAT_F", (getPos _projectile) vectorAdd [0,0,10], [], 0, "FLY"];
    [_heat, -90, 0] call BIS_fnc_setPitchBank;
    _heat setVelocity [0,0,-50];
    deleteVehicle _projectile;
    [_pfhId] call CBA_fnc_removePerFrameHandler;
  };

  if(!alive _projectile) exitWith {
    [_pfhId] call CBA_fnc_removePerFrameHandler;
  };
}, 0.5, [_extra, time, vectorNormalized _velocity]] call CBA_fnc_addPerFrameHandler;
