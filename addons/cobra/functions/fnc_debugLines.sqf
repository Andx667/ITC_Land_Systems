#include "..\script_component.hpp"

/*
 * Author: Andx
 * Lines of the debug overlay (common_fnc_registerDebug) for a COBRA radar: whether it scans (it does not while it
 * moves), its range and the direction the scan reads from the turret, and what it has found so far. Clients read the
 * copy of the server's results that cobra XEH_postInit keeps.
 *
 * Arguments:
 * 0: COBRA radar <OBJECT>
 *
 * Return Value:
 * Lines, each [text, color] <ARRAY>
 *
 * Example:
 * [_cobra] call itc_land_cobra_fnc_debugLines
 *
 * Public: No
 */

params [["_cobra", objNull, [objNull]]];

private _scanning = vectorMagnitude (velocity _cobra) < 1;
private _impacts = {CBA_missionTime <= _x # 1} count GVAR(activeShells);

[
    [
        format [
            "COBRA %1 | range %2 m | facing %3 deg +-%4",
            ["moving, not scanning", "scanning"] select _scanning, GVAR(range), round (DEBUG_FACING(_cobra)), DEBUG_ARC
        ],
        [[1, 0.6, 0.2, 1], [0.3, 1, 0.3, 1]] select _scanning
    ],
    [
        format ["impacts predicted %1 | firing positions %2 | engagements %3", _impacts, count GVAR(firingPositions), count GVAR(engagements)],
        [0.85, 0.85, 0.85, 1]
    ]
]
