#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Determines guidance stage transitions ("SEP" -> "TURN" -> "GLIDE") for a guided
 * projectile based on elapsed separation time and vertical velocity, and returns the
 * current stage together with the active steer point.
 *
 * Arguments:
 * 0: Projectile <Object>
 * 1: Steer point <Position>
 * 2: Frame time <Number>
 * 3: Horizontal angle to target <Number>
 * 4: Vertical angle to target <Number>
 * 5: Guidance stage <String>
 * 6: Target coordinates <Position>
 * 7: Azimuth <Number>
 * 8: Time guidance/separation started <Number>
 *
 * Return Value:
 * Guidance stage and steer point <Array>
 * 0: Guidance stage <String>
 * 1: Steer point <Position>
 *
 * Example:
 * [_projectile, _steerPoint, _frameTime, _angleX, _angleY, _stage, _targetCoordinates, _azimuth, _time] call itc_land_vls_fnc_determineSteerPoint
 *
 * Public: No
 */

params ["_projectile", "_steerPoint","_frameTime", "_angleX", "_angleY","_stage","_targetCoordinates","_azimuth","_time"];
//(_this select 0) params ["_projectile", "_ammo", "_position", "_targetCoordinates", "_stage", "_time", "_angle", "_lastFrameTime","_azimuth","_steerPoint"];
private _return = [_stage, _steerPoint];
if(_stage == "SEP") exitWith {
  if(time > _time + 1) then {
    //if(_azimuth > 0) then {
    //  _return set [0, "NAV"];
    //  _return set [1,(_this call itc_air_sdb_fnc_navSteerPoint)];
    //} else {
      _return set [0, "TURN"];
    //};
  };
  _return
};


if(_stage == "TURN") exitWith {
  if((velocity _projectile) # 2 < 1) then {
    _return set [0, "GLIDE"];
  };
  _return
};

if(_stage == "GLIDE") then {
  _return set [1,_targetCoordinates];
  //[ASLtoAGL (_return # 1), "ColorYellow"] call test_fnc_mark;
};
_return
