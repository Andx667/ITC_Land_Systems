#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The BCS fire commands to the guns (SEND ADJ / SEND FFE): the firing line of each gun for the
 * selected battery solution goes over the datalink to its linked gun's sight, with the round,
 * count, fuze and target as fire orders. Adjust fire sends the adjusting gun one round per
 * correction; fire for effect sends every gun the mission's count. The FDC's datalink ID is the
 * origin (the BCS connects the player when it starts).
 *
 * Arguments:
 * 0: Fire mission <ARRAY>
 * 1: Solutions of the mission: [battery solutions, gun solutions] (bcs_fnc_calcSolutions) <ARRAY>
 * 2: Fire for effect (else adjust fire) <BOOL>
 * 3: Index of the adjusting gun in the gun solutions <NUMBER>
 *
 * Return Value:
 * Report: [lines <ARRAY of STRINGs>, kind "" (sent to all) / "warn" / "bad"] <ARRAY>
 *
 * Example:
 * [_mission, _solutions, true, 0] call itc_land_tablet_fnc_bcsSendFireData
 *
 * Public: No
 */

params ["_mission", "_solutions", "_ffe", "_adjustingGun"];

_mission params ["_ident", "", "_targetPage", "_engagePage", "_curSolution"];
_engagePage params ["", "", "", "", "", ["_magazineType", ""], ["_roundCount", 1], ["_fuzeMode", ""]];
_solutions params ["_btySolutions", "_gunSolutions"];

private _origin = ACE_player getVariable [QEGVAR(datalink,id), ""];
if (_origin == "") exitWith {[[LLSTRING(Bcs_DatalinkNotConnected)], "warn"]};
private _batterySolution = _btySolutions param [_curSolution min (count _btySolutions - 1) max 0, []];
if (_batterySolution isEqualTo []) exitWith {[[LLSTRING(Bcs_NoSolutions)], "bad"]};

private _phase = ["ADJ", "FFE"] select _ffe;
if (!_ffe) then {_roundCount = 1};
private _lines = if (_ffe) then {_gunSolutions} else {[_gunSolutions param [_adjustingGun max 0, []]] select {_x isNotEqualTo []}};
private _sent = [];
private _notLinked = [];
private _noSolution = [];
{
    _x params ["_num", "_gunSolutionList"];
    private _gunVehicle = (GVAR(bcs_bty_guns) param [GVAR(bcs_bty_guns) findIf {_x # 0 == _num}, []]) param [6, objNull];
    private _id = if (alive _gunVehicle) then {_gunVehicle getVariable [QEGVAR(datalink,id), ""]} else {""};
    private _line = [_gunSolutionList, _batterySolution] call EFUNC(bcs,matchGunSolution);
    switch (true) do {
        case (_id == ""): {_notLinked pushBack _num};
        case (_line isEqualTo []): {_noSolution pushBack _num};
        default {
            [_id, _origin, "fdc", "fireData", [_ident, _phase, _line, _magazineType, _roundCount, _fuzeMode, _targetPage param [6, []]]] call EFUNC(datalink,transmit);
            _sent pushBack _num;
        };
    };
} forEach _lines;

private _report = [format [LLSTRING(Bcs_SentTo), _ident, _phase, [_sent joinString ", ", "-"] select (_sent isEqualTo [])]];
if (_notLinked isNotEqualTo []) then {_report pushBack format [LLSTRING(Bcs_NotLinked), _notLinked joinString ", "]};
if (_noSolution isNotEqualTo []) then {_report pushBack format [LLSTRING(Bcs_NoSolutionFor), _noSolution joinString ", "]};
[_report, ["", "warn"] select (_notLinked isNotEqualTo [] || {_noSolution isNotEqualTo []})]
