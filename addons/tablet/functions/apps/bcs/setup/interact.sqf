#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS setup page interactions: "save" reads the battery name and selected battery
 * type; "addGun" reads the gun number, grid, elevation and direction fields, converts the
 * grid to a map position, and either adds a new gun or updates an existing one (matched by
 * number); "removeGun" deletes the selected gun from the battery.
 *
 * Arguments:
 * 0: Action identifier ("save", "addGun" or "removeGun") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["addGun"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
#include "..\..\..\BCS_idc_defines.hpp"
#include "..\bcsDefines.hpp"

private _listIndex = lbCurSel 4315;
switch(_action) do {
  case "save": {
    GVAR(bcs_bty_name) = UITEXT(4303);
    private _gunIndex = lbCurSel 4304;
    GVAR(bcs_bty_type) = [_gunIndex, lbData [4304, _gunIndex]];
  };
  case "addGun": {
    private _num = UITEXT(4306);
    private _posStr = UITEXT(4308);
    private _elev = UINUMBER(4310);
    private _dir = UINUMBER(4312);
    private _pos = [_posStr, false] call ace_common_fnc_getMapPosFromGrid;
    _pos = _pos vectorAdd [0,0,_elev];
    private _gunString = format["%1               %2              %3               %4", _num, _posStr, _elev, _dir];
    private _gunData = [_num, _posStr, _pos, _elev, _dir];

    private _gun = GVAR(bcs_bty_guns) findIf {_x # 0 == _num};
    if(_gun == -1) then {
      lbAdd [4315, _gunString];
      GVAR(bcs_bty_guns) pushBack _gunData;
    } else {
      GVAR(bcs_bty_guns) set [_gun, _gunData];
      [findDisplay 32562] call itc_land_tablet_fnc_pageInit;
    };
  };
  case "removeGun": {
    GVAR(bcs_bty_guns) deleteAt _listIndex;
    lbDelete [4315, _listIndex];
  };
};
