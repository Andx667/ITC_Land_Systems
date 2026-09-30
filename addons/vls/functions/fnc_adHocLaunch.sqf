#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Reads the ad-hoc target grid, elevation and impact-angle fields from the VLS ad-hoc
 * targeting dialog, converts the grid to a world position, stores the resulting target
 * data on the current vehicle, then fires the currently selected weapon at it.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this] call itc_land_vls_fnc_adHocLaunch
 *
 * Public: No
 */

private _vehicle = [] call EFUNC(common,getCurVehicle);

//get data from edit fields
private _targetGrid = ctrlText 4106;
_vehicle setVariable ["ITC_Land_VLS_adHocData_grid",_targetGrid,true];

private _targetElev = parseNumber(ctrlText 4108);
_vehicle setVariable ["ITC_Land_VLS_adHocData_elev", _targetElev, true];

private _targetPos = [_targetGrid, _targetElev] call EFUNC(common,gridToPos);

private _targetAngl = _vehicle getVariable ["ITC_Land_VLS_adHocData_angl",[1,"45"]];

_vehicle setVariable ["itc_land_vls_targetAngl",  parseNumber (_targetAngl # 1), true];
itc_land_target_IAtest = _vehicle getVariable "itc_land_vls_targetAngl";

_vehicle setVariable ["itc_land_vls_targetPos", _targetPos, true];
itc_land_target_test = _vehicle getVariable "itc_land_vls_targetPos";

_vehicle fire (currentWeapon _vehicle);
