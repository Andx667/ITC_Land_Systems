/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS locStores page interactions: "addLocation" reads the location number, grid,
 * elevation and friendly/enemy fields, converts the grid to a map position, and either adds
 * a new stored location or updates an existing one (matched by number) before re-initializing
 * the page; "removeLocation" deletes the selected location from the list.
 *
 * Arguments:
 * 0: Action identifier ("addLocation" or "removeLocation") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["addLocation"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
#include "..\bcsDefines.hpp"

switch(_action) do {
  case "addLocation": {
    _num = UITEXT(5402);
    _posStr = UITEXT(5404);
    _elev = UINUMBER(5406);
    _friendly = lbText [5408, (lbCurSel 5408)];
    _pos = [_posStr, false] call ace_common_fnc_getMapPosFromGrid;
    _pos = _pos vectorAdd [0,0,_elev];
    _locString = format["%1               %2              %3               %4", _num, _posStr, _elev, _friendly];
    _locData = [_num, _posStr, _pos, _elev, _friendly];

    _location = bcs_locations findIf {_x # 0 == _num};
    if(_location == -1) then {
      lbAdd [5411, _locString];
      bcs_locations pushBack _locData;
    } else {
      bcs_locations set [_location, _locData];
      [findDisplay 32562] call itc_land_tablet_fnc_pageInit;
    };
  };
  case "removeLocation": {
    _index = lbCurSel 5411;
    bcs_locations deleteAt _index;
    lbDelete [5411, _index];
  };
};
