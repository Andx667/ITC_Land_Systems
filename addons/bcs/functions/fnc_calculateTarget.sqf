#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Calculates a target position from one of four input methods: a grid
 * reference, a shift from a known point, a polar shift from a known point,
 * or a quick-lay offset from the battery's own position.
 *
 * Arguments:
 * 0: Target type index <NUMBER> (0: Grid, 1: Shift from known point, 2: Polar from known point, 3: Quick lay from battery position)
 * 1: Known point index <NUMBER> (index into bcs_locations, used for types 1 and 2)
 * 2: Input 0 <STRING> (type 0: grid reference; types 1-3: OT direction in mils)
 * 3: Input 1 <STRING> (type 0: target elevation; types 1-3: add/drop distance)
 * 4: Input 2 <STRING> (type 1: left/right distance; types 2-3: up/down elevation adjustment; unused for type 0)
 * 5: Input 3 <STRING> (type 1: up/down elevation adjustment; unused for types 0, 2 and 3)
 *
 * Return Value:
 * Calculated target position <ARRAY> (Position ASL)
 *
 * Example:
 * [_targetTypeIndex, _kpi, _in0, _in1, _in2, _in3] call itc_land_bcs_fnc_calculateTarget
 *
 * Public: No
 */

params ["_targetTypeIndex","_kpi","_in0","_in1","_in2","_in3"];
_targetPos = [];
if(_targetTypeIndex == 0) then {
  _pos = [_in0, false] call ace_common_fnc_getMapPosFromGrid;
  _targetPos = [_pos # 0, _pos # 1, parseNumber _in1];
};
if(_targetTypeIndex == 1 || _targetTypeIndex == 2) then {
  _targetPos = (bcs_locations # _kpi) # 2;
};
if(_targetTypeIndex == 3) then {
  _targetPos = [bcs_bty_guns] call FUNC(getBatteryPosition);
};

if(_targetTypeIndex > 0) then {
  _lr = if(_targetTypeIndex == 1) then [{_in2},{"0"}];
  _ud = if(_targetTypeIndex == 1) then [{_in3},{_in2}];
  _targetPos = [_targetPos, parseNumber _in0, parseNumber _in1, parseNumber _lr, parseNumber _ud] call FUNC(adjustGrid);
};
_targetPos
