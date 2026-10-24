#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles interactions on the CBR Data page. On the "savePos" action, reads the currently selected
 * engagement from the combo box and pushes its grid position as a new entry onto the BCS stored-locations list.
 * On "counterFire" it hands the engagement's firing position to the BCS and switches to it: the BCS opens
 * a new fire mission on it at the engagement step (see the BCS app's init.sqf).
 *
 * Arguments:
 * 0: The interaction identifier dispatched from the page's UI controls <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["savePos"] call itc_land_tablet_fnc_pageInteract;
 *
 * Public: No
 */

params ["_action"];

switch (_action) do {
    case "savePos": {
        private _posIndex = lbCurSel 136001;
        private _engagements = missionNamespace getVariable ["itc_land_cobra_engagements", []];
        if (_posIndex < 0 || {_posIndex >= count _engagements}) exitWith {};
        private _engagement = _engagements # _posIndex;
        [_engagement # 0, _engagement # 2 # 0] call FUNC(bcsRecordPoint);
    };
    case "counterFire": {
        private _posIndex = lbCurSel 136001;
        private _engagements = missionNamespace getVariable ["itc_land_cobra_engagements", []];
        if (_posIndex < 0 || {_posIndex >= count _engagements}) exitWith {};
        GVAR(bcs_pendingTarget) = [(_engagements # _posIndex) # 2 # 0];
        ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(app), "bcs"];
    };
};
