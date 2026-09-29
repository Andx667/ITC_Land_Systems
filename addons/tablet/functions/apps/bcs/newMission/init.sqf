#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS newMission page: shows the newMission workspace panel, sets its header
 * and target input fields from the current mission's target data, and fills the target type
 * and known-location combo boxes.
 *
 * Arguments:
 * 0: Tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562] call itc_land_tablet_fnc_pageInit
 *
 * Public: No
 */

params ["_display"];
#include "..\..\..\BCS_idc_defines.hpp"
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;
ctrlShow [13504, true];
[_display, IDC_workspace_header, _ident] call FUNC(setText);
SETTEXT(6400,_ident);
SETTEXT(6401,_in0);
SETTEXT(6402,_in1);
SETTEXT(6403,_in2);
SETTEXT(6404,_in3);
[6100, ["Grid","Shift","Polar","QuickLay"], _targetTypeIndex] call FUNC(fillComboBox);
private _knownPoints = GVAR(bcs_locations) apply {_x #  0};
[6101, _knownPoints, _kpi] call FUNC(fillComboBox);
