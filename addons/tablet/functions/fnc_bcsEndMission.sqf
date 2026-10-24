#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * End of mission for the BCS fire mission shown: the linked guns' fire orders for it are cleared
 * over the datalink, its target is optionally recorded as a known point, and the mission is deleted.
 *
 * Arguments:
 * 0: Record the target as a known point <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call itc_land_tablet_fnc_bcsEndMission
 *
 * Public: No
 */

params ["_recordTarget"];

private _mission = GVAR(bcs_missions) param [GVAR(bcs_mission_index), []];
if (_mission isEqualTo []) exitWith {};
_mission params ["_ident", "", "_targetPage"];

private _origin = ACE_player getVariable [QEGVAR(datalink,id), ""];
if (_origin != "") then {
    {
        private _gunVehicle = _x param [6, objNull];
        private _id = if (alive _gunVehicle) then {_gunVehicle getVariable [QEGVAR(datalink,id), ""]} else {""};
        if (_id != "") then {
            [_id, _origin, "fdc", "endMission", [_ident]] call EFUNC(datalink,transmit);
        };
    } forEach GVAR(bcs_bty_guns);
};
if (_recordTarget) then {
    [_ident, _targetPage param [6, [0, 0, 0]]] call FUNC(bcsRecordPoint);
};
GVAR(bcs_missions) deleteAt GVAR(bcs_mission_index);
