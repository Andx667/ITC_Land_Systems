#include "..\script_component.hpp"
#include "apps\bcs\bcsDefines.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Starts the BCS for the classic and the HTML tablet: seeds the mission namespace with default
 * BCS variables (splash time, mission code, battery data, etc.) if not already set, and connects
 * the player to the datalink (once per unit, so again after a respawn): fire data sent to the
 * linked guns goes out with the player's ID as the origin, and the guns' shot reports and the
 * targets observers send from the ITC optics come back to it (a target becomes a Location Stores
 * entry, TGT01, TGT02, ...). A target another app handed over (itc_land_tablet_bcs_pendingTarget,
 * COBRA counter-fire) becomes a new fire mission.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Name of the page to open: settings, or the engagement page of the handed-over target's fire mission <STRING>
 *
 * Example:
 * [] call itc_land_tablet_fnc_bcsInit
 *
 * Public: No
 */

private _defaults = [
    [QGVAR(bcs_splash_time), 5], // the FDC calls SPLASH 5 s before impact
    [QGVAR(bcs_mission_code), "FM"],
    [QGVAR(bcs_mission_start), 1],

    [QGVAR(bcs_bty_name), ""],
    [QGVAR(bcs_bty_type), [0,"G155"]],
    [QGVAR(bcs_bty_guns), []],
    [QGVAR(bcs_locations), []],
    [QGVAR(bcs_missions), []],
    [QGVAR(bcs_mission_index), 0]
];
{
    if (isNil{missionNamespace getVariable (_x # 0)}) then {
        missionNamespace setVariable [_x # 0, _x # 1];
    };
} forEach _defaults;

if (missionNamespace getVariable [QGVAR(bcs_datalinkUnit), objNull] != ACE_player) then {
    GVAR(bcs_datalinkUnit) = ACE_player;
    [ACE_player] call EFUNC(datalink,connectPlayer);
    // a linked gun reports the first shot of the fire data it got: that starts SHOT and SPLASH,
    // unless the mission is already counting down (the other guns of the salvo)
    [ACE_player, "fdc", "shot", {
        params ["", "_transmission"];
        (_transmission select 4) params [["_ident", "", [""]], ["_timeOfFlight", 0, [0]]];
        private _mission = GVAR(bcs_missions) param [GVAR(bcs_missions) findIf {_x # 0 == _ident}, []];
        if (_mission isEqualTo [] || {(_mission # 6) > time}) exitWith {};
        [_ident, _timeOfFlight] call FUNC(bcsShot);
        [format [LLSTRING(Bcs_ShotReported), _ident, round _timeOfFlight]] call ace_common_fnc_displayTextStructured;
    }] call EFUNC(datalink,registerEvent);
    // a target an observer sends from the ITC optics (to every FDC): a new entry in the Location Stores
    [ACE_player, "observer", "target", {
        params ["", "_transmission"];
        (_transmission select 4) params [["_observer", "", [""]], ["_side", sideUnknown, [sideUnknown]], ["_targetPos", [], [[]]]];
        if !(_targetPos isEqualTypeArray [0, 0, 0]) exitWith {};
        if ((side group ACE_player) getFriend _side < 0.6) exitWith {};
        _targetPos = [_targetPos # 0, _targetPos # 1, round (_targetPos # 2)];
        GVAR(bcs_observerTargets) = (missionNamespace getVariable [QGVAR(bcs_observerTargets), 0]) + 1;
        private _id = format ["TGT%1", [GVAR(bcs_observerTargets), 2] call CBA_fnc_formatNumber];
        private _grid = [_targetPos] call EFUNC(common,posToGrid);
        GVAR(bcs_locations) pushBack [_id, _grid, _targetPos, _targetPos # 2, false];
        playSound "TacticalPing3";
        [format [LLSTRING(Bcs_TargetReceived), _id, _observer, _grid, _targetPos # 2], 2.5] call ace_common_fnc_displayTextStructured;
        // the classic Location Stores page shows it right away (the HTML tablet redraws by itself)
        private _vehicle = [] call EFUNC(common,getCurVehicle);
        if (!isNull findDisplay 32562 && {_vehicle getVariable [QGVAR(app), ""] == "bcs"} && {_vehicle getVariable [QGVAR(page), ""] == "locStores"}) then {
            [findDisplay 32562] call itc_land_tablet_fnc_pageInit;
        };
    }] call EFUNC(datalink,registerEvent);
};

// a target another app handed over (COBRA counter-fire): a new fire mission on it, at the engagement step
private _startPage = "settings";
private _pending = missionNamespace getVariable [QGVAR(bcs_pendingTarget), []];
if (_pending isNotEqualTo []) then {
    GVAR(bcs_pendingTarget) = nil;
    _pending params ["_targetPos"];
    _targetPos = [_targetPos # 0, _targetPos # 1, round (_targetPos # 2)];
    private _ident = GENIDENT;
    private _mission = EMPTYMISSION(_ident);
    _mission set [1, "engageMission"];
    _mission set [2, [0, -1, ([_targetPos] call ace_common_fnc_getMapGridFromPos) joinString "", str (_targetPos # 2), "0", "0", _targetPos]];
    GVAR(bcs_missions) pushBack _mission;
    GVAR(bcs_mission_index) = (count GVAR(bcs_missions)) - 1;
    _startPage = "engageMission";
};
_startPage
