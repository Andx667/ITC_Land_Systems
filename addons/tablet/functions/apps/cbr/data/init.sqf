#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the CBR Data page: shows the data panel, sets its header text, and fills the engagements
 * combo box with formatted COBRA engagement entries (grid position, shot count, last shot time), selecting the first entry.
 *
 * Arguments:
 * 0: The tablet dialog's display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_pageInit;
 *
 * Public: No
 */

#include "..\..\..\BCS_idc_defines.hpp"
params ["_display"];
ctrlShow [13602, true];

[_display, IDC_workspace_header, "Data"] call EFUNC(common,ctrlSetText);

private _firesStrings = itc_land_cobra_engagements apply {
  private _pos = [_x # 2 # 0] call ace_common_fnc_getMapGridFromPos;
  format["%1            POS %2 %3           Shots %4         Last Shot %5",
    _x # 0,
    _pos # 0, _pos # 1,
    _x # 1,
    (_x # 5) call BIS_fnc_timeToString
  ]
};
[136001,_firesStrings,0] call FUNC(fillComboBox);
