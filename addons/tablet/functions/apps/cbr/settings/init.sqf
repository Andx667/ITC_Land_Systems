#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the CBR Settings page: shows the settings panel, populates the COBRA ID text field from
 * the player's stored ID, and sets the page header text to "Settings".
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
ctrlShow [13600, true];
ctrlSetText [10400, player getVariable ["itc_land_cobra_id",""]];
[_display, IDC_workspace_header, "Settings"] call FUNC(setText);
