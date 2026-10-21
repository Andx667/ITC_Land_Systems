#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS newMission page interactions: "targetType" shows/hides and relabels the
 * target input fields based on the selected target type (Grid/Shift/Polar/QuickLay);
 * "load" fills the input fields from a selected known location; "save" calculates the
 * target position from the entered data, stores it on the mission's target data and
 * advances the mission to the engageMission page.
 *
 * Arguments:
 * 0: Action identifier ("targetType", "load" or "save") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["save"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
//player sideChat "type switch";
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;
private _display = findDisplay 32562;
private _typeIndex = lbCurSel 6100;
if (_action == "targetType") then {
    //player sideChat format["ti %1",_typeIndex];
    {[_display, _x, 1] call EFUNC(common,ctrlSetFade);}forEach [6019,6403,6404,6019,6101,6601];
    private _labelTexts = ["","","",""];
    private _tooltips = ["","","",""];
    private _showFields = [];
    switch (_typeIndex) do {
        case 0: {
            _labelTexts = [LLSTRING(Bcs_Grid),LLSTRING(Bcs_Elevation),"",""];
            _tooltips = [LLSTRING(Grid_Tooltip),LLSTRING(Altitude_Tooltip),"",""];
            _showFields = [6019,6101,6601];
        };
        case 1: {
            _labelTexts = ["OT","AD","LR","UD"];
            _tooltips = [LLSTRING(target_field1_text_Tooltip),LLSTRING(target_field2_text_Tooltip),LLSTRING(target_field3_text_Tooltip),LLSTRING(target_field4_text_Tooltip)];
            _showFields = [6403,6404,6019,6101];
        };
        case 2: {
            _labelTexts = [LLSTRING(Bcs_Direction),LLSTRING(Bcs_Distance),"VI",""];
            _tooltips = [LLSTRING(target_polar_direction_Tooltip),LLSTRING(target_polar_distance_Tooltip),LLSTRING(target_vi_Tooltip),""];
            _showFields = [6403,6019,6101];
        };
        case 3: {
            _labelTexts = [LLSTRING(Bcs_Direction),LLSTRING(Bcs_Distance),"VI",""];
            _tooltips = [LLSTRING(target_quicklay_direction_Tooltip),LLSTRING(target_quicklay_distance_Tooltip),LLSTRING(target_vi_Tooltip),""];
            _showFields = [6403];
        };
    };
    {
        [_display, _x,_labelTexts select _forEachIndex] call EFUNC(common,ctrlSetText);
        (_display displayCtrl _x) ctrlSetTooltip (_tooltips select _forEachIndex);
    } forEach [6020,6021,6022,6023];
    {[_display, _x, 0] call EFUNC(common,ctrlSetFade);}forEach _showFields;
};


if (_action == "load") then {
    private _pointIndex = lbCurSel 6101;
    if (_pointIndex > -1) then {
        private _point = GVAR(bcs_locations) # _pointIndex;
        [_display, 6401, _point # 1] call EFUNC(common,ctrlSetText);
        [_display, 6402, str (_point # 3)] call EFUNC(common,ctrlSetText);
    };
};

if (_action == "save") then {
    private _targetPage = [_typeIndex, lbCurSel 6101, UITEXT(6401),UITEXT(6402),UITEXT(6403),UITEXT(6404)];
    private _targetPos = _targetPage call EFUNC(bcs,calculateTarget);
    _targetPage set [6, _targetPos];
    _mission set [2, _targetPage];
    _mission set [0, UITEXT(6400)];
    _mission set [1, "engageMission"];
    SAVEMISSION(_mission);
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "engageMission"];
};
