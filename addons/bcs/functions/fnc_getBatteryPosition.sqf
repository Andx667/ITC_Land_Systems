#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Calculates the average (centre) position of a list of howitzers by summing
 * each gun's easting, northing and elevation and dividing by the gun count.
 *
 * Arguments:
 * 0: Guns in the battery <ARRAY> of [gun number <NUMBER>, position string <STRING>, position <ARRAY> (Position ASL), elevation <NUMBER>, direction <NUMBER>]
 *
 * Return Value:
 * Average battery position <ARRAY> (Position ASL), or [0, 0, 0] if the list is empty
 *
 * Example:
 * [_gunList] call itc_land_bcs_fnc_getBatteryPosition
 *
 * Public: No
 */

params ["_gunList"];
if(count _gunList == 0) exitWith {[0,0,0]};
//add up all the eastings, northings and elevations
_totalEasting = 0;
_totalNorthing = 0;
_totalElev = 0;

{
  (_x # 2) params ["_easting", "_northing", "_elev"];
  _totalEasting = _totalEasting + _easting;
  _totalNorthing  = _totalNorthing + _northing;
  _totalElev = _totalElev + _elev;
}forEach _gunList;

_number = count _gunList;
//return the totals divided by the gun count
[_totalEasting / _number, _totalNorthing / _number, _totalElev / _number]
