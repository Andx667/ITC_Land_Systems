#include "..\script_component.hpp"

/*
 * Author: Yax
 * Initializes a vehicle's APS (Active Protection System) modules from its "itc_land_aps" config class, and stores the resulting
 * module array in the vehicle's "itc_land_aps_modules" variable (public) if any modules are defined.
 *
 * Arguments:
 * 0: Vehicle to initialize APS modules for <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle] call itc_land_aps_fnc_vehicleInit
 *
 * Public: No
 */
params ["_vehicle"];

private _config = (configOf _vehicle >> "itc_land_aps");

if (isClass _config) then {
  private _apsArray = [];
  private _apsSystems = "true" configClasses _config;
  { // forEach _apsSystems
    private _aps = [
      getText (_x >> "displayName"),
      ((_x >> "position") call BIS_fnc_getCfgData),
      ((_x >> "turret") call BIS_fnc_getCfgData),
      getNumber (_x >> "direction"),
      getNumber (_x >> "traverse"),
      getNumber (_x >> "elevate"),
      getNumber (_x >> "range"),
      getNumber (_x >> "munitions"),
      getNumber (_x >> "pk"),
      getNumber (_x >> "reloadTime"),
      (getNumber (_x >> "trigger") == 1),
      0
    ];
    _apsArray pushBack _aps;
  } forEach _apsSystems;

  if (_apsArray isNotEqualTo []) then {
    _vehicle setVariable ["itc_land_aps_modules", _apsArray, true];
  };
};
