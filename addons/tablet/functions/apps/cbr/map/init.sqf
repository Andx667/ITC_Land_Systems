#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the CBR Map page: shows the map panel and sets its header text to "Map".
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
ctrlShow [13601, true];

[_display, IDC_workspace_header, "Map"] call FUNC(setText);
