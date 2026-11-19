#include "..\script_component.hpp"

/*
 * Author: Andx
 * Extra drawing of the debug overlay (common_fnc_registerDebug) for the BCS: on the FDC's machine a line to every gun
 * its battery links; for every gun near the camera with fire data, a line to the FDC that sent it (found by its
 * datalink ID) and one to the target, with the mission at the target. Lines are drawn however far the other end is.
 *
 * Arguments:
 * 0: Objects near the camera <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_objects] call itc_land_bcs_fnc_debugDrawLinks
 *
 * Public: No
 */

params [["_objects", [], [[]]]];

private _player = ASLToAGL (getPosASLVisual vehicle ACE_player);
{
    private _gun = _x param [6, objNull];
    if (alive _gun) then {
        drawLine3D [_player, ASLToAGL (getPosASLVisual _gun), [1, 0.85, 0.3, 1]];
    };
} forEach (missionNamespace getVariable [QEGVAR(tablet,bcs_bty_guns), []]);

{
    private _gun = _x;
    (_gun getVariable [QGVAR(fireData), []]) params [["_mission", ""], "", "", ["_origin", ""], "", "", ["_targetPos", []]];

    if (_mission != "") then {
        private _gunPos = ASLToAGL (getPosASLVisual _gun);

        if (_origin != "") then {
            private _candidates = allUnits + vehicles;
            private _index = _candidates findIf {(_x getVariable [QEGVAR(datalink,id), ""]) == _origin};
            if (_index != -1) then {
                drawLine3D [_gunPos, ASLToAGL (getPosASLVisual vehicle (_candidates # _index)), [0.4, 0.85, 1, 1]];
            };
        };

        if (count _targetPos == 3) then {
            private _target = ASLToAGL _targetPos;
            drawLine3D [_gunPos, _target, [1, 0.2, 0.2, 1]];
            [_target vectorAdd [0, 0, 2], format ["TARGET %1", _mission], [1, 0.2, 0.2, 1]] call EFUNC(common,debugText);
        };
    };
} forEach (_objects select {[_x] call FUNC(getGunBatteryType) != ""});
