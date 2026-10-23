#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Draws the COBRA picture on a map control (classic and HTML tablet): each COBRA radar with its
 * 44 degree search sector, the firing positions it located (with their round count) and the
 * predicted impact points of the shells still in flight (with the seconds to impact).
 *
 * Arguments:
 * 0: Map control <CONTROL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_map] call itc_land_tablet_fnc_cbrDrawMap
 *
 * Public: No
 */

params ["_map"];

{
    private _direction = deg (_x animationPhase "mainTurret");
    _direction = (getDir _x - _direction);
    if (_direction > 360) then {_direction = _direction - 360;};
    private _position = getPos _x;
    _map drawIcon ["iconExplosiveGPDirectional",[0,0,1,1],_position, 24, 24, 0, "",0,0.05,"TahomaB","right"];
    _map drawLine [_x, (_position getPos [10000, _direction + 22]),[0,0,1,1]];
    _map drawLine [_x, (_position getPos [10000, _direction - 22]),[0,0,1,1]];
} forEach (missionNamespace getVariable ["itc_land_cobras",[]]);

{
    _x params ["_roundCount","_origins","_lastActive"];
    _map drawIcon ["iconExplosiveGPDirectional",[1,0,0,1],_origins # 0, 24, 24, 0, str _roundCount,0,0.05,"TahomaB","right"];
} forEach (missionNamespace getVariable ["itc_land_cobra_firingPositions",[]]);
{
    _x params ["_impactPoint","_impactTime"];
    if (cba_missionTime < _impactTime) then {
        _map drawIcon ["a3\ui_f\data\Map\Markers\Military\destroy_CA.paa",[1,0,0,1],_impactPoint, 24, 24, 0, str round(_impactTime - cba_missionTime),0,0.05,"TahomaB","right"];
    };
} forEach (missionNamespace getVariable ["itc_land_cobra_activeShells",[]]);
