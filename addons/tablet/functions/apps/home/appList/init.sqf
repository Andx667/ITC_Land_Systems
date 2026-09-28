#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the Home App List page: shows the app-list panel, un-fades the exit/menu controls, then
 * for each of the three app slots configured on the current vehicle, looks up its display name and
 * interface list from config and writes them into the matching labels, or clears/hides the slot's
 * controls if no app is assigned to it.
 *
 * Arguments:
 * 0: The tablet dialog's display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_pageInit;
 *
 * Public: No
 */

params ["_display"];
#include "..\..\..\BCS_idc_defines.hpp"
ctrlShow [13301, true];
[_display, 15010, 0] call FUNC(setFade);
[_display, 15011, 0] call FUNC(setFade);

private _vehicle = [] call EFUNC(common,getCurVehicle);
private _apps = _vehicle getVariable "apps";
{
  if(_x < count _apps) then {
    private _name = (configFile >> "itc_land" >> "apps" >> _apps # _x >> "displayName")  call BIS_fnc_getCfgData;
    private _ifaces = (configFile >> "itc_land" >> "apps" >> _apps # _x >> "interfaces")  call BIS_fnc_getCfgData;

    private _displayedName = toUpper (format ["APP %1: %2",_x + 1, _name]);
    private _displayedifaces = toUpper ( _ifaces );

    [_display, 91000 + _x, _displayedName] call FUNC(setText);
    [_display, 91010 + _x, _displayedifaces] call FUNC(setText);

  } else {
    [_display, 91000 + _x, ""] call FUNC(setText);
    [_display, 91010 + _x, ""] call FUNC(setText);
    ctrlShow [91020 + _x, false];
  };
}forEach [0,1,2];
