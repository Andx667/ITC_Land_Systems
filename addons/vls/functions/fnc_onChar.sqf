#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Handles the ad-hoc target dialog's onChar event: whenever the grid, elevation or
 * name edit field is typed into, saves its current text to the corresponding variable
 * on the current vehicle.
 *
 * Arguments:
 * 0: Control that received the character <Control>
 * 1: Character code <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_control, _charCode] call itc_land_vls_fnc_onChar
 *
 * Public: No
 */

params ["_control", "_charCode"];
private _vehicle = [] call EFUNC(common,getCurVehicle);
private _idc = ctrlIDC _control;
//systemChat str [ctrlClassName _control,_idc];

switch (_idc) do {
    case 4106: {
        private _targetGrid = ctrlText 4106;
        //systemChat _targetGrid;
        _vehicle setVariable ["ITC_Land_VLS_adHocData_grid",_targetGrid,true];
    };
    case 4108: {
        private _targetElev = parseNumber(ctrlText 4108);
        //systemChat str _targetElev;
        _vehicle setVariable ["ITC_Land_VLS_adHocData_elev", _targetElev, true];
    };
    case 4112: {
        private _targetName = ctrlText 4112;
        //systemChat _targetName;
        _vehicle setVariable ["ITC_Land_VLS_adHocData_name", _targetName, true];
    };
};
