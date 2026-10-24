#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles interactions on the SPG FCS page. On "calc" it computes the firing solutions on the entered
 * target grid/elevation for the selected magazine (tablet_fnc_fcsCalculate). On "prev"/"next" it steps
 * through them (tablet_fnc_fcsStep). The page's render.sqf redraws the readout.
 *
 * Arguments:
 * 0: The interaction action identifier ("calc", "prev", "next") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["calc"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
ITC_CURVEHICLE

switch (_action) do {
    case "calc": {
        [_vehicle, ctrlText 1400, parseNumber (ctrlText 1401), lbData [1402, lbCurSel 1402]] call FUNC(fcsCalculate);
    };
    case "prev": {[_vehicle, -1] call FUNC(fcsStep)};
    case "next": {[_vehicle, 1] call FUNC(fcsStep)};
};
