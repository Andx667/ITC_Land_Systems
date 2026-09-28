#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Looks up the tablet mounted on the given vehicle and opens it, if one
 * is defined.
 *
 * Arguments:
 * 0: Vehicle to open the mounted tablet of <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorObject] call itc_land_tablet_fnc_openVehicleTablet
 *
 * Public: No
 */

params ["_vehicle"];

private _tablet = (configOf _vehicle >> "itc_land" >> "mountedTablet")  call BIS_fnc_getCfgData;

if(!isNil{_tablet}) then {
  [_tablet,_vehicle] call FUNC(open);
};
