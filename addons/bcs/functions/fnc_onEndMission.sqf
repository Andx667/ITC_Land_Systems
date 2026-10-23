#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Datalink handler for the end of a fire mission ("fdc"/"endMission"): clears the gun's fire
 * orders if they are for that mission, which hides the FCI ORDERS panel. The firing data stays
 * selected in the sight. Runs on the server, which connected the gun.
 *
 * Arguments:
 * 0: Gun <OBJECT>
 * 1: Transmission [destination, origin, header, type, [mission <STRING>]] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_gun, ["0112", "0111", "fdc", "endMission", ["FM0001"]]] call itc_land_bcs_fnc_onEndMission
 *
 * Public: No
 */

params ["_gun", "_transmission"];
(_transmission select 4) params [["_mission", "", [""]]];

if (((_gun getVariable [QGVAR(fireData), []]) param [0, ""]) != _mission) exitWith {};

_gun setVariable [QGVAR(fireData), nil, true];
