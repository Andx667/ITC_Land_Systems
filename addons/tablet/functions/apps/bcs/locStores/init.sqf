#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS locStores page: shows the locStores workspace panel, sets its header,
 * fills the friendly/enemy combo box, and populates the stored locations list box.
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
ctrlShow [13503, true];

[_display, IDC_workspace_header, "Location Stores"] call FUNC(setText);

[5408,["no","yes"],0] call FUNC(fillComboBox);

lbClear 5411;
private _locationsStrings = GVAR(bcs_locations) apply {format["%1               %2              %3               %4", _x # 0, _x # 1, _x # 3, _x # 4]};
[5411, _locationsStrings, 0] call FUNC(fillComboBox);
