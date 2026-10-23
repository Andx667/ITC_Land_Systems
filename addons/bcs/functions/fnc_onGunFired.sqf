#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Fired handler of an ITC gun: the first shot after fire data from the FDC arrived is reported
 * back to the FDC ("fdc"/"shot" with the mission and the time of flight), which starts its SHOT
 * and SPLASH countdown. Later shots of the same fire data, and shots without fire data (a local
 * SPG app solution), report nothing. Acts only where the gun is local.
 *
 * Arguments:
 * 0: Gun <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_gun] call itc_land_bcs_fnc_onGunFired
 *
 * Public: No
 */

params ["_gun"];

if (!local _gun) exitWith {};

(_gun getVariable [QGVAR(fireData), []]) params [["_mission", ""], "", "", ["_origin", ""], "", "", "", ["_received", -1]];
if (_mission == "" || {_gun getVariable [QGVAR(shotReported), -2] isEqualTo _received}) exitWith {};
_gun setVariable [QGVAR(shotReported), _received];

private _id = _gun getVariable [QEGVAR(datalink,id), ""];
if (_id == "" || {_origin == ""}) exitWith {};

private _timeOfFlight = ([_gun] call EFUNC(common,getFireSolution)) param [4, 0];
[_origin, _id, "fdc", "shot", [_mission, _timeOfFlight]] call EFUNC(datalink,transmit);
