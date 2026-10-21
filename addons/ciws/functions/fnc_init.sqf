#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Post-init entry point for the CIWS system. Reads the list of interceptable ammo base classes
 * from config (itc_land_ciws >> interceptable), and adds CuratorGroupPlaced/CuratorObjectPlaced
 * event handlers to every curator, including ones created later, so that units and objects placed
 * via Zeus have their vehicle radar switched on (Zeus-spawned assets otherwise spawn with radar
 * disabled). The radar is switched on by the radarOn event on the machine that owns the vehicle.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_ciws_fnc_init
 *
 * Public: No
 */

GVAR(interceptable) = (configFile >> "itc_land_ciws" >> "interceptable") call BIS_fnc_getCfgData; //list of ciws munitions to allow people to add more in missions

[QGVAR(radarOn), FUNC(radarOn)] call CBA_fnc_addEventHandler;

//Add EHs to wake up objects placed by a zeus which have radars which would otherwise not have them on.
["ModuleCurator_F", "Init", {
  params ["_curator"];
  _curator addEventHandler ["CuratorGroupPlaced", {
    params ["", "_group"];
    {
      private _vehicle = vehicle _x;
      [QGVAR(radarOn), [_vehicle], _vehicle] call CBA_fnc_targetEvent;
    } forEach units _group;
  }];
  _curator addEventHandler ["CuratorObjectPlaced", {
    params ["", "_entity"];
    [QGVAR(radarOn), [_entity], _entity] call CBA_fnc_targetEvent;
  }];
}, true, [], true] call CBA_fnc_addClassEventHandler;
