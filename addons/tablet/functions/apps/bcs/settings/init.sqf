#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS settings page: shows the settings workspace panel, sets its header,
 * and populates the splash time, mission code and mission start number fields from the
 * current BCS settings.
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
ctrlShow [13501, true];

[_display, IDC_workspace_header, "Battery Control System Settings"] call FUNC(setText);

SETTEXT(3205,str bcs_splash_time);
SETTEXT(3206,bcs_mission_code);
SETTEXT(3207,str bcs_mission_start);
