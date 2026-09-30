#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Reads the ad-hoc grid, elevation, impact-angle and name fields from the VLS targeting
 * dialog, saves them to the current vehicle, and appends the resulting target as a new
 * entry in the vehicle's saved-target list box and target array.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this] call itc_land_vls_fnc_saveTGT
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
private _targetAnglNum = parseNumber (_targetAngl # 1);

private _targetName = ctrlText 4112;
_vehicle setVariable ["ITC_Land_VLS_adHocData_name", _targetName, true];

private _TGTData = [_targetName,_targetPos,_targetAnglNum];
private _TGTLabel = format ["%1: GRID: %2 - ELEV: %3m - ANGLE: %4",_targetName,_targetGrid,_targetElev,_targetAngl # 1];

private _index = lbAdd [4103, format["%1", _TGTLabel]];
lbSetData [4103, _index, str _TGTData];

private _TGTRecord = [_TGTLabel, str _TGTData];
private _targetsArray = _vehicle getVariable ["ITC_Land_VLS_TGTList",[]];
_targetsArray pushBack _TGTRecord;
_vehicle setVariable ["ITC_Land_VLS_TGTList",_targetsArray,true];
