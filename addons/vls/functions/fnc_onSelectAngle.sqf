#include "..\script_component.hpp"

params ["_control","_index"];

private _vehicle = [] call EFUNC(common,getCurVehicle);
private _targetAngl = lbData [4110,_index];
_vehicle setVariable ["ITC_Land_VLS_adHocData_angl",[_index,_targetAngl],true];
