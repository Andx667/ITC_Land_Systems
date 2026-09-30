#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the artillery apps' status page: shows its controls and sets the workspace header text.
 *
 * Arguments:
 * 0: The tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_pageInit
 *
 * Public: No
 */

params ["_display"];
#include "..\..\..\BCS_idc_defines.hpp"
ctrlShow [13420, true];
[_display, IDC_workspace_header, "Vehicle Status"] call EFUNC(common,ctrlSetText);
