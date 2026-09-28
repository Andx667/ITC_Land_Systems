/*
 * Author: ToadBall, Yax, VKing
 * Fills out a tablet page's controls from an input array of [key, value]
 * pairs, calling each matching control's configured setMethod with the
 * value.
 *
 * Arguments:
 * 0: Tablet page config class name <String>
 * 1: Array of [key, value] pairs to apply <Array>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["page_bcs_firemission_engage", [["grid", "0000000000"]]] call itc_land_tablet_fnc_arrayToPage
 *
 * Public: No
 */
params ["_page", "_input"];
private _controls = (configFile >> "itc_land_tablet" >> _page >> "Controls") call BIS_fnc_getCfgSubClasses;
{
  _x params ["_key", "_value"];
  {
    private _controlKey = getText (configFile >> "itc_land_tablet" >> "page_bcs_firemission_engage" >> "Controls" >> _x >> "key");
    private _setMethod = getText (configFile >> "itc_land_tablet" >> "page_bcs_firemission_engage" >> "Controls" >> _x >> "setMethod");
    if(_controlKey == _key) then {
      _value call (compile _setMethod);
    };
  }forEach _controls;
}forEach _input;
