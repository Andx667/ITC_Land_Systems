#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles interactions on the CBR Data page. On the "savePos" action, reads the currently selected
 * engagement from the combo box and pushes its grid position as a new entry onto the BCS stored-locations list.
 *
 * Arguments:
 * 0: The interaction identifier dispatched from the page's UI controls <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["savePos"] call itc_land_tablet_fnc_pageInteract;
 *
 * Public: No
 */

params ["_action"];

switch(_action) do {
  case "savePos": {
    private _posIndex = lbCurSel 136001;
    private _pos = itc_land_cobra_engagements # _posIndex;
    if(isNil{GVAR(bcs_locations)}) then {GVAR(bcs_locations) = [];};
    GVAR(bcs_locations) pushBack [_pos # 0, [_pos # 2 # 0] call EFUNC(common,posToGrid), _pos # 2 # 0 , round (_pos # 2 # 0 # 2), false];
  };
};
