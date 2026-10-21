#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Registers a COBRA counter-battery radar vehicle with the server-side COBRA
 * simulation (see itc_land_cobra_fnc_scan) and publishes the updated list of
 * COBRA vehicles to all clients. Runs from the vehicle's init event, which
 * fires on every machine; only the server registers.
 *
 * Arguments:
 * 0: COBRA-equipped vehicle to initialize <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_cbr] call itc_land_cobra_fnc_vehicleInit
 *
 * Public: No
 */

params ["_cbr"];
if (!isServer) exitWith {};

itc_land_cobras pushBackUnique _cbr;
publicVariable "itc_land_cobras";

//private _linkID = _cbr getVariable ["init_datalink_id",""];
//[_cbr,"","object_register",true] call EFUNC(datalink,connect);

//[_cbr, "cobra", "getData", {_this call FUNC(getCobraData);}] call EFUNC(datalink,registerEvent);


/*
[player,"AB01","object_register", true] call EFUNC(datalink,connect);

[player, "cobra", "returnData", {
  params ["_target","_transmission"];
  _transmission params ["_destination","_origin","_header","_type","_data"];
  _data params ["_vehicle","_origins","_engagements","_activeShells"];
  _cobras = _target getVariable [QGVAR(vehicles),[]];
  _target setVariable [QGVAR(vehicles),_cobras + [_vehicle]];
  _target setVariable [QGVAR(firingPositions),_origins];
  _target setVariable [QGVAR(engagements),_engagements];
  _target setVariable [QGVAR(activeShells),_activeShells];
}] call EFUNC(datalink,registerEvent);

[player, "cobra", "shellDetected", {
  params ["_target","_transmission"];
  _transmission params ["_destination","_origin","_header","_type","_data"];
  _data params ["_position","_tof"];
  _activeShells = _target getVariable [QGVAR(activeShells),[]];
  _target setVariable [QGVAR(activeShells),_activeShells + [[_position, _tof + cba_missionTime]]];
}] call EFUNC(datalink,registerEvent);

["0111","AB01","cobra","getData",""] call EFUNC(datalink,transmit);

GVAR(map_app_render) = {
  params ["_display"];
  private _map = (_display displayCtrl 10001);
  {
    private _direction = direction _x;
    private _position = getPos _x;
    _map drawIcon ["iconExplosiveGPDirectional",[0,0,1,1],_position, 24, 24, 0, _x getVariable QEGVAR(datalink,id),0,0.05,"TahomaB","right"];
    _map drawLine [_x, (_position getPos [10000, _direction + 22]),[0,0,1,1]];
    _map drawLine [_x, (_position getPos [10000, _direction - 22]),[0,0,1,1]];
  }forEach (player getVariable [QGVAR(vehicles),[]]);
  {
    _x params ["_roundCount","_origins","_lastActive"];
    _map drawIcon ["iconExplosiveGPDirectional",[1,0,0,1],_origins # 0, 24, 24, 0, str _roundcount,0,0.05,"TahomaB","right"];
  }forEach (player getVariable [QGVAR(firingPositions),[]]);
  {
    _x params ["_impactPoint","_impactTime"];
    if(cba_missionTime < _impactTime) then {
      _map drawIcon ["a3\ui_f\data\Map\Markers\Military\destroy_CA.paa",[1,0,0,1],_impactPoint, 24, 24, 0, str round(_impactTime - cba_missionTime),0,0.05,"TahomaB","right"];
    };
  }forEach (player getVariable [QGVAR(activeShells),[]]);
};


*/
