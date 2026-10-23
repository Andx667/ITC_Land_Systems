#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Datalink handler for fire data the FDC sends to a gun ("fdc"/"fireData"). Makes the received
 * firing line the gun's selected fire solution, the one its gunner sight and SPG app show
 * (itc_land_tablet_fcs_solutions, replacing a local SPG app solution), stores the fire orders
 * (itc_land_bcs_fireData, shown in the sight's FCI ORDERS panel and applied by the ammunition
 * handler's FDC ORDERS) and alerts the crew. Runs on the server, which connected the gun.
 *
 * Arguments:
 * 0: Gun <OBJECT>
 * 1: Transmission [destination, origin, header, type, data]; data is [mission <STRING>,
 *    phase "ADJ" or "FFE" <STRING>, firing line <ARRAY>, magazine <STRING>, round count <NUMBER>,
 *    fuze mode <STRING>, target position ASL <ARRAY>] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_gun, ["0112", "0111", "fdc", "fireData", ["FM0001", "FFE", _line, "itc_land_g155hex", 3, "pd", _pos]]] call itc_land_bcs_fnc_onFireData
 *
 * Public: No
 */

params ["_gun", "_transmission"];
_transmission params ["", "_origin", "", "", "_data"];
_data params [
    ["_mission", "", [""]],
    ["_phase", "", [""]],
    ["_line", [], [[]]],
    ["_magazine", "", [""]],
    ["_count", 1, [0]],
    ["_fuzeMode", "", [""]],
    ["_targetPos", [], [[]]]
];

if (!alive _gun || {count _line < 9}) exitWith {};

_gun setVariable ["itc_land_tablet_fcs_solutions", [_line], true];
_gun setVariable ["itc_land_tablet_fcs_solutions_index", 0, true];
// the receive time tells fire data apart, so each one reports its first shot once
_gun setVariable [QGVAR(fireData), [_mission, _phase, _magazine, _origin, _count, _fuzeMode, _targetPos, CBA_missionTime], true];

// the crew, and the operator of a UAV gun (the Hammer 2)
private _crew = (crew _gun) + ((UAVControl _gun) select {_x isEqualType objNull && {!isNull _x}});
[QGVAR(fireDataReceived), [_gun, _mission, _phase], _crew] call CBA_fnc_targetEvent;
