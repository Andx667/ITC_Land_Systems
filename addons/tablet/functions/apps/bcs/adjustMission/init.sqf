#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS adjustMission page: shows the adjustMission workspace panel and
 * sets its header text to "Adjust Mission".
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
ctrlShow [13507, true];

[_display, IDC_workspace_header, "Adjust Mission"] call FUNC(setText);
