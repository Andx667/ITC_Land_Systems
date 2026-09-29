#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Post-init entry point for the CIWS system. Registers the "Enable CIWS
 * System" CBA setting, reads the list of interceptable ammo base classes
 * from config (itc_land_ciws >> interceptable), and adds
 * CuratorGroupPlaced/CuratorObjectPlaced event handlers to every curator so
 * that units and objects placed via Zeus have their vehicle radar switched
 * on (Zeus-spawned assets otherwise spawn with radar disabled).
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

[QGVAR(enabled), "CHECKBOX", "Enable CIWS System", "ITC Land", [true]] call CBA_Settings_fnc_init; //ciws system enabling options
GVAR(interceptable) = (configFile >> "itc_land_ciws" >> "interceptable") call BIS_fnc_getCfgData; //list of ciws munitions to allow people to add more in missions

//Add EHs to wake up objects placed by a zeus which have radars which would otherwise not have them on.
{
  private _groupEH = _x addEventHandler ["CuratorGroupPlaced", {
    params ["_curator", "_group"];
    {
      (vehicle _x) setVehicleRadar 1;
    } forEach units _group
  }];
  private _objectEH = _x addEventHandler ["CuratorObjectPlaced", {
    params ["_curator", "_entity"];
    _entity setVehicleRadar 1;
  }];

  _x setVariable ["ITC_Land_RadarOnEH",[_groupEH,_objectEH],true];
} forEach allCurators;
