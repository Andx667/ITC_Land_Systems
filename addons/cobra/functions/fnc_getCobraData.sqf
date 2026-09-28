#include "..\script_component.hpp"

params ["_target","_transmission"];
_transmission params ["_destination","_origin","_header","_type","_data"];

private _returnData = [
  _target,
  _target getVariable "firingPositions",
  _target getVariable "engagements",
  _target getVariable "activeShells"
];
[_origin,_target getVariable "datalink_id","cobra","returnData",_returnData] call EFUNC(datalink,transmit);
