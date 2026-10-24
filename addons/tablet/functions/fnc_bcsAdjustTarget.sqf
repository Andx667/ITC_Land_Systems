#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * An observer's correction to the BCS fire mission's target: add/drop, left/right and up/down
 * along the observer-target direction (bcs_fnc_adjustGrid). The direction is kept for the
 * mission's next correction (itc_land_tablet_bcs_lastOT).
 *
 * Arguments:
 * 0: Fire mission <ARRAY>
 * 1: Observer-target direction, mils as typed <STRING>
 * 2: Add (+) / drop (-) (m) <NUMBER>
 * 3: Right (+) / left (-) (m) <NUMBER>
 * 4: Up (+) / down (-) (m) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_mission, "1600", 100, 0, 0] call itc_land_tablet_fnc_bcsAdjustTarget
 *
 * Public: No
 */

params ["_mission", "_direction", "_addDrop", "_leftRight", "_upDown"];

private _targetPage = _mission # 2;
private _ot = [_direction, [GVAR(bcs_bty_type) # 1] call EFUNC(common,getMilSystem)] call EFUNC(common,parseMils);
_targetPage set [6, [_targetPage # 6, _ot, _addDrop, _leftRight, _upDown] call EFUNC(bcs,adjustGrid)];
_mission set [2, _targetPage];

if (isNil QGVAR(bcs_lastOT)) then {GVAR(bcs_lastOT) = createHashMap};
GVAR(bcs_lastOT) set [_mission # 0, _direction];
