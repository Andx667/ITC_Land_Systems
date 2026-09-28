#include "..\script_component.hpp"

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
if (isNIl "ITC_Land_COBRA_SirenTypes") then {
  missionNameSpace setVariable ["ITC_Land_COBRA_SirenTypes",[_sirenType],true];
} else {
  ITC_Land_COBRA_SirenTypes append [_sirenType];
};

if ((count _this) < 4) then {
  _siren setVariable ["sirenParams",[true,"alarm",250,1.75],true];
} else {
  _siren setVariable ["sirenParams",[true,_sirenSound,_sirenDistance,_sirenDuration],true];
};

_this;
