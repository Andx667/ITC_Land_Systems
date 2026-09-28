#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Renders the BCS engageMission page's adjust/FFE gun, shell, count and fuze selection combo
 * boxes from the engagement option lists.
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

[7500, itc_land_firemission_engage_adj_gns, 0] call FUNC(fillComboBox);
[7501, itc_land_firemission_engage_adj_shl, 0] call FUNC(fillComboBox);
[7502, itc_land_firemission_engage_ffe_gns, 0] call FUNC(fillComboBox);
[7503, itc_land_firemission_engage_ffe_shl, 0] call FUNC(fillComboBox);
[7504, itc_land_firemission_engage_ffe_cnt, 0] call FUNC(fillComboBox);
[7505, itc_land_firemission_engage_ffe_fze, 0] call FUNC(fillComboBox);
