#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Listens on the datalink for the targets observers send from the ITC optics (to every FDC),
 * from the start of the mission and for every player: each becomes a Location Stores entry
 * (TGT01, TGT02, ...), so an FDC that opens the BCS only later still has the targets sent
 * before. Only a player who has opened the BCS gets the ping and the hint. Runs once per unit,
 * so again after a respawn or for a remote-controlled unit.
 *
 * Arguments:
 * 0: Player unit <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ACE_player] call itc_land_tablet_fnc_bcsListenTargets
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]]];

if (isNull _unit || {_unit getVariable [QGVAR(bcs_listensTargets), false]}) exitWith {};
_unit setVariable [QGVAR(bcs_listensTargets), true];

[_unit] call EFUNC(datalink,connectPlayer);
[_unit, "observer", "target", {
    params ["", "_transmission"];
    (_transmission select 4) params [["_observer", "", [""]], ["_side", sideUnknown, [sideUnknown]], ["_targetPos", [], [[]]]];
    if !(_targetPos isEqualTypeArray [0, 0, 0]) exitWith {};
    if ((side group ACE_player) getFriend _side < 0.6) exitWith {};
    _targetPos = [_targetPos # 0, _targetPos # 1, round (_targetPos # 2)];
    GVAR(bcs_observerTargets) = (missionNamespace getVariable [QGVAR(bcs_observerTargets), 0]) + 1;
    private _id = format ["TGT%1", [GVAR(bcs_observerTargets), 2] call CBA_fnc_formatNumber];
    [_id, _targetPos] call FUNC(bcsRecordPoint);

    // only an FDC (a player who has opened the BCS) is told
    if (missionNamespace getVariable [QGVAR(bcs_datalinkUnit), objNull] != ACE_player) exitWith {};
    private _grid = [_targetPos] call EFUNC(common,posToGrid);
    playSound "TacticalPing3";
    [format [LLSTRING(Bcs_TargetReceived), _id, _observer, _grid, _targetPos # 2], 2.5] call ace_common_fnc_displayTextStructured;
    // the classic Location Stores page shows it right away (the HTML tablet redraws by itself)
    private _vehicle = [] call EFUNC(common,getCurVehicle);
    if (!isNull findDisplay 32562 && {_vehicle getVariable [QGVAR(app), ""] == "bcs"} && {_vehicle getVariable [QGVAR(page), ""] == "locStores"}) then {
        [findDisplay 32562] call FUNC(pageInit);
    };
}] call EFUNC(datalink,registerEvent);
