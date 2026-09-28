#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Clears and repopulates a listbox/combobox control with the given
 * entries, selects an index, and optionally attaches per-entry data.
 *
 * Arguments:
 * 0: Listbox control IDC <Number>
 * 1: Entries to add <Array>
 * 2: Index to select, -1 for none <Number>
 * 3: Per-entry data to attach via lbSetData <Array>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1904, ["Mode A", "Mode B"], 0, ["a", "b"]] call itc_land_tablet_fnc_fillComboBox
 *
 * Public: No
 */

params ["_idc", "_entries", "_selected", "_data"];
lbClear _idc;
{
  lbAdd [_idc, _x];
}forEach _entries;
if(_selected > -1) then {
  lbSetCurSel [_idc, _selected];
};

if(!isNil{_data}) then {
  {
    lbSetData [_idc, _forEachIndex, _x];
  }forEach _data;
};
