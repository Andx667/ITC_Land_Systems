#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The BCS fire mission's target (the new mission page's NEXT): its position from the target type
 * and inputs (bcs_fnc_calculateTarget), then on to the engagement. Without its input a target type
 * has no position: Grid needs a grid, Shift and Polar a known point, QuickLay the battery's guns.
 * The mission stays as it was then, instead of saving one the solutions cannot use.
 *
 * Arguments:
 * 0: Fire mission <ARRAY>
 * 1: Mission name <STRING>
 * 2: Target type: 0 Grid, 1 Shift, 2 Polar, 3 QuickLay <NUMBER>
 * 3: Known point index, -1 for none <NUMBER>
 * 4: The type's four inputs <ARRAY of STRINGs>
 *
 * Return Value:
 * Target set <BOOL>
 *
 * Example:
 * [_mission, "FM0001", 0, -1, ["01234567", "120", "", ""]] call itc_land_tablet_fnc_bcsSetTarget
 *
 * Public: No
 */

params ["_mission", "_name", "_typeIndex", "_kpi", "_inputs"];

private _targetPage = [_typeIndex, _kpi] + _inputs;
private _validInput = switch (_typeIndex) do {
    case 0: {(_inputs # 0) regexMatch GRID_REGEX};
    case 1;
    case 2: {_kpi > -1 && {_kpi < count GVAR(bcs_locations)}};
    case 3: {GVAR(bcs_bty_guns) isNotEqualTo []};
    default {false};
};
private _targetPos = if (_validInput) then {_targetPage call EFUNC(bcs,calculateTarget)} else {[]};
if !(_targetPos isEqualTypeArray [0, 0, 0]) exitWith {false};

_targetPage set [6, _targetPos];
_mission set [0, _name];
_mission set [1, "engageMission"];
_mission set [2, _targetPage];
true
