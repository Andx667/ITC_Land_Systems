#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Places the HTML tablet's native map control (COBRA map) over the slot the page reported
 * (GVAR(web) "mapRect", fractions of the page), or hides it when the page has no map slot.
 * A shown map takes the focus, so it is drawn above the browser; a hidden map gives it back.
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

params [["_ctrl", controlNull, [controlNull]]];

private _map = (ctrlParent _ctrl) displayCtrl 32574;
if (isNull _map) exitWith {};
private _rect = GVAR(web) getOrDefault ["mapRect", []];
if (_rect isEqualTo []) exitWith {
    // the map had the focus while it was shown: give it back to the page, for its fields
    if (ctrlShown _map) then {ctrlSetFocus _ctrl};
    _map ctrlShow false;
};

(ctrlPosition _ctrl) params ["_px", "_py", "_pw", "_ph"];
_rect params ["_rx", "_ry", "_rw", "_rh"];
_map ctrlSetPosition [_px + _rx * _pw, _py + _ry * _ph, _rw * _pw, _rh * _ph];
_map ctrlCommit 0;
_map ctrlShow true;
// the focused control is drawn on top: once a click focuses the browser, it covers the map;
// the page reports the slot again every 2 s, which brings the map back to the top
ctrlSetFocus _map;
