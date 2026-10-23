#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Places the HTML tablet's native map control (COBRA map) over the slot the page reported
 * (GVAR(web) "mapRect", fractions of the page), or hides it when the page has no map slot.
 *
 * Arguments:
 * 0: Browser control <CONTROL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ctrl] call itc_land_tablet_fnc_webPlaceMap
 *
 * Public: No
 */

params ["_ctrl"];

private _map = (ctrlParent _ctrl) displayCtrl 32574;
if (isNull _map) exitWith {};
private _rect = GVAR(web) getOrDefault ["mapRect", []];
if (_rect isEqualTo []) exitWith {_map ctrlShow false};

(ctrlPosition _ctrl) params ["_px", "_py", "_pw", "_ph"];
_rect params ["_rx", "_ry", "_rw", "_rh"];
_map ctrlSetPosition [_px + _rx * _pw, _py + _ry * _ph, _rw * _pw, _rh * _ph];
_map ctrlCommit 0;
_map ctrlShow true;
