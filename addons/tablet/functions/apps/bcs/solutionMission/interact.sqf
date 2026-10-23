#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS solutionMission page interactions: "back" returns to engageMission, "adjust"
 * goes to adjustMission; "solup"/"soldn" step through the available firing solutions;
 * "shot" records the time the mission will land; "sendadj" sends the firing line of the gun
 * selected in the list (the first gun if none is) and "sendffe" those of all guns over the
 * datalink to the linked guns' sights, with the round, count and fuze as fire orders; any action
 * containing "eom" ends the mission (optionally saving its target as a known location first via
 * "eomsave"), tells the linked guns it ended and returns to locStores. In all cases the page is re-initialized afterward without
 * recalculating the solutions.
 *
 * Arguments:
 * 0: Action identifier ("back", "adjust", "solup", "soldn", "shot", "sendadj", "sendffe", "eom" or "eomsave") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["shot"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;
GVAR(bcs_solutions) params ["_btySolutions", "_gunSolutions"];
if (_action == "back") then {
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "engageMission"];
};
if (_action == "adjust") then {
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "adjustMission"];
};

if (_action == "solup") then {
    if (_curSolution < _solutionLimit) then {
        _mission set [4, _curSolution + 1];
    };
};
if (_action == "soldn") then {
    _mission set [4, (_curSolution - 1) max 0];
};

if (_action == "shot") then {
    [_ident, (_btySolutions # _curSolution) # 4] call FUNC(bcsShot);
};

if (_action in ["sendadj", "sendffe"]) then {
    // the FDC's datalink ID is the origin; the BCS connects the player when it opens
    private _origin = ACE_player getVariable [QEGVAR(datalink,id), ""];
    if (_origin == "") exitWith {
        [LLSTRING(Bcs_DatalinkNotConnected)] call ace_common_fnc_displayTextStructured;
    };
    private _batterySolution = _btySolutions param [_curSolution, []];
    if (_batterySolution isEqualTo []) exitWith {
        [LLSTRING(Bcs_NoSolutions)] call ace_common_fnc_displayTextStructured;
    };

    private _ffe = _action == "sendffe";
    private _phase = ["ADJ", "FFE"] select _ffe;
    private _selectedGun = _gunSolutions param [(lbCurSel 8500) max 0, []];
    private _lines = if (_ffe) then {_gunSolutions} else {[_selectedGun] select {_x isNotEqualTo []}};
    private _sent = [];
    private _notLinked = [];
    private _noSolution = [];
    {
        _x params ["_num", "_gunSolutionList"];
        private _gunIndex = GVAR(bcs_bty_guns) findIf {_x # 0 == _num};
        private _vehicle = (GVAR(bcs_bty_guns) param [_gunIndex, []]) param [6, objNull];
        private _id = if (alive _vehicle) then {_vehicle getVariable [QEGVAR(datalink,id), ""]} else {""};
        private _line = [_gunSolutionList, _batterySolution] call EFUNC(bcs,matchGunSolution);
        switch (true) do {
            case (_id == ""): {_notLinked pushBack _num};
            case (_line isEqualTo []): {_noSolution pushBack _num};
            default {
                [_id, _origin, "fdc", "fireData", [_ident, _phase, _line, _magazineType, _roundCount, _fuzeMode, _tgtPos]] call EFUNC(datalink,transmit);
                _sent pushBack _num;
            };
        };
    } forEach _lines;

    private _report = [format [LLSTRING(Bcs_SentTo), _ident, _phase, [_sent joinString ", ", "-"] select (_sent isEqualTo [])]];
    if (_notLinked isNotEqualTo []) then {_report pushBack format [LLSTRING(Bcs_NotLinked), _notLinked joinString ", "]};
    if (_noSolution isNotEqualTo []) then {_report pushBack format [LLSTRING(Bcs_NoSolutionFor), _noSolution joinString ", "]};
    [_report joinString "<br/>", 1 + count _report] call ace_common_fnc_displayTextStructured;
};

if ("eom" in _action) then {
    // end of mission for the linked guns: their fire orders for it are cleared
    private _origin = ACE_player getVariable [QEGVAR(datalink,id), ""];
    if (_origin != "") then {
        {
            private _vehicle = _x param [6, objNull];
            private _id = if (alive _vehicle) then {_vehicle getVariable [QEGVAR(datalink,id), ""]} else {""};
            if (_id != "") then {
                [_id, _origin, "fdc", "endMission", [_ident]] call EFUNC(datalink,transmit);
            };
        } forEach GVAR(bcs_bty_guns);
    };
    if (_action == "eomsave") then {
        GVAR(bcs_locations) pushBack [_ident, [_tgtPos] call EFUNC(common,posToGrid), _tgtPos , round (_tgtPos # 2), false];
    };
    GVAR(bcs_missions) deleteAt GVAR(bcs_mission_index);
    ([] call EFUNC(common,getCurVehicle)) setVariable [QGVAR(page), "locStores"];
};
[findDisplay 32562, false] call itc_land_tablet_fnc_pageInit;
