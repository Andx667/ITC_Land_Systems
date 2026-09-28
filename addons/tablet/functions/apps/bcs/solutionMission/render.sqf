/*
 * Author: ToadBall, Yax, VKing
 * Renders the BCS solutionMission page's time-to-impact (TTI) countdown label, showing the
 * remaining time until the recorded shot lands, or clearing it once the shot has landed.
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
if(_shotEnd > time) then {
  _text = format["TTI %1", round(_shotEnd - time)];
  SETTEXT(8021,_text);
} else {
  SETTEXT(8021,"");
};
