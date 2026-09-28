#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Refreshes the CBR Data page each frame by rebuilding the engagements combo box with the current
 * list of formatted COBRA engagement entries, without forcing a selection.
 *
 * Arguments:
 * 0: The tablet dialog's display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_pageRender;
 *
 * Public: No
 */

params ["_display"];
private _firesStrings = itc_land_cobra_engagements apply {
  private _pos = [_x # 2 # 0] call ace_common_fnc_getMapGridFromPos;
  format["%1            POS %2 %3           Shots %4         Last Shot %5",
    _x # 0,
    _pos # 0, _pos # 1,
    _x # 1,
    (_x # 5) call BIS_fnc_timeToString
  ]
};
[136001,_firesStrings,-1] call FUNC(fillComboBox);
