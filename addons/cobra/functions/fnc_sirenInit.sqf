#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Registers an object as a COBRA-linked siren (server-only): records its class
 * in the mission-wide siren-type registry and stores its siren sound class,
 * trigger distance and repeat duration on the object, falling back to default
 * alarm values if fewer than 4 arguments are supplied.
 *
 * Arguments:
 * 0: Siren object/vehicle to register <Object>
 * 1: Sound class name to play for this siren <String>
 * 2: Distance at which the siren sound is audible <Number>
 * 3: Duration between siren sound repeats, in seconds <Number>
 *
 * Return Value:
 * The input arguments array <Array>
 *
 * Example:
 * [_siren, _sirenSound, _sirenDistance, _sirenDuration] call itc_land_cobra_fnc_sirenInit
 *
 * Public: No
 */

//[this,"vtolAlarm",100,2] call FUNC(sirenInit)

if (!isServer) exitWith {};
params ["_siren","_sirenSound","_sirenDistance","_sirenDuration"];

//_siren setVariable ["datalinkMethods",["EFUNC(datalink,receiveIDRegistry)","FUNC(sirenTrigger)"]];

//[_siren, "cobra", "shellDetected", {
//  (_this # 0) say3D ["alarmCar",150,0.8];
//}] call EFUNC(datalink,registerEvent);
//private _linkID = _siren getVariable ["init_datalink_id",""];
//[_siren,_linkID,"object_register", true] call EFUNC(datalink,connect);

private _sirenType = typeOf _siren;
if (isNil "ITC_Land_COBRA_SirenTypes") then {
  missionNamespace setVariable ["ITC_Land_COBRA_SirenTypes",[_sirenType],true];
} else {
  ITC_Land_COBRA_SirenTypes append [_sirenType];
};

if ((count _this) < 4) then {
  _siren setVariable [QGVAR(sirenParams),[true,"alarm",250,1.75],true];
} else {
  _siren setVariable [QGVAR(sirenParams),[true,_sirenSound,_sirenDistance,_sirenDuration],true];
};

_this;
