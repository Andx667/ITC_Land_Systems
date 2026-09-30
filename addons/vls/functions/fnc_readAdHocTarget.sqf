#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Reads the ad-hoc target grid and elevation from the VLS dialog's edit boxes, remembers them
 * on the vehicle and converts them to a world position.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * [grid, elevation in meters MSL, world position] <ARRAY>
 *
 * Example:
 * [_vehicle] call itc_land_vls_fnc_readAdHocTarget
 *
 * Public: No
 */

params ["_vehicle"];

private _targetGrid = ctrlText 4106;
_vehicle setVariable ["ITC_Land_VLS_adHocData_grid", _targetGrid, true];

private _targetElev = parseNumber (ctrlText 4108);
_vehicle setVariable ["ITC_Land_VLS_adHocData_elev", _targetElev, true];

[_targetGrid, _targetElev, [_targetGrid, _targetElev] call EFUNC(common,gridToPos)]
