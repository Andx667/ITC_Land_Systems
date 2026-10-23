#include "..\..\..\..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Renders the SPG app's FCS page: redraws the solution readout whenever the vehicle's solutions,
 * the selected one or the FDC fire data change, so data the FDC sends shows up while the page
 * is open.
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

params ["_display"];
ITC_CURVEHICLE

private _state = [
    _vehicle getVariable ["itc_land_tablet_fcs_solutions", []],
    _vehicle getVariable ["itc_land_tablet_fcs_solutions_index", 0],
    _vehicle getVariable [QEGVAR(bcs,fireData), []]
];
if (_state isEqualTo (_display getVariable [QGVAR(fcsShown), []])) exitWith {};
_display setVariable [QGVAR(fcsShown), _state];

(_display displayCtrl 1100) ctrlSetStructuredText parseText ([_vehicle] call FUNC(fcsSolutionText));
(_display displayCtrl 1100) ctrlCommit 0;
