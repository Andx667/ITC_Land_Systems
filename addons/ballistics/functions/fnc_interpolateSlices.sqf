#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Linearly interpolates element-wise between two arrays of numbers by a given factor.
 *
 * Arguments:
 * 0: Lower/first array of values <ARRAY>
 * 1: Upper/second array of values <ARRAY>
 * 2: Interpolation factor, 0-1 <NUMBER>
 *
 * Return Value:
 * Element-wise linearly interpolated array <ARRAY>
 *
 * Example:
 * [[0,0], [10,10], 0.5] call itc_land_ballistics_fnc_interpolateSlices
 *
 * Public: No
 */

params ["_sliceLow", "_sliceHigh", "_factor"];
private _ret = [];
for "_i" from 0 to ((count _sliceLow) - 1) step 1 do {
 private _x1 = _sliceLow # _i;
 private _x2 = _sliceHigh # _i;
 _ret pushBack (_x1 + ((_x2 - _x1) * _factor));
};
_ret
