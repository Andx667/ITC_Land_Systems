#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Renders the BCS solutionMission page's time-to-impact (TTI) countdown label, showing the
 * remaining time until the recorded shot lands, or clearing it once the shot has landed, and
 * appends each linked gun's ammunition handler status to its row in the gun list.
 *
 * Arguments:
 * 0: Tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562] call itc_land_tablet_fnc_pageRender
 *
 * Public: No
 */

params ["_display"];
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;
if (_shotEnd > time) then {
    private _text = format[LLSTRING(Bcs_TimeToImpact), round(_shotEnd - time)];
    SETTEXT(8021,_text);
} else {
    SETTEXT(8021,"");
};

// the loader status of each linked gun, as its crew sees it
{
    _x params ["_text", "_vehicle"];
    if (alive _vehicle) then {
        private _rowText = format ["%1     %2", _text, [_vehicle] call EFUNC(common,getGunStatusText)];
        if (lbText [8500, _forEachIndex] != _rowText) then {lbSetText [8500, _forEachIndex, _rowText]};
    };
} forEach (missionNamespace getVariable [QGVAR(bcs_solutionRows), []]);
