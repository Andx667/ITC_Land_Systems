#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Returns an array of COBRA siren type class names, gathered from both
 * config-defined siren types (any CfgVehicles class with a positive
 * ITC_Land_COBRA_SirenTypes config entry) and mission-defined siren types
 * (registered at runtime via fnc_sirenInit), in a format depending on mode.
 *
 * Arguments:
 * 0: Return mode: 0 = single flattened array of all types, 1 = nested array [configTypes, missionTypes] <Number>
 *
 * Return Value:
 * Array of siren-equipped class names, format depending on mode <Array>
 *
 * Example:
 * [0] call itc_land_cobra_fnc_sirenTypes
 *
 * Public: No
 */

params ["_mode"];
private _configTypes = [];
{
  if (getNumber _x > 0) then {
    _configTypes pushBackUnique configName _x;
  };
} forEach configProperties [configFile >> "ITC_Land_COBRA_SirenTypes", "isNumber _x"];
private _missionTypes = missionNamespace getVariable ["ITC_Land_COBRA_SirenTypes",[]];
private _allTypes = [];

switch (_mode) do {
  case 0 : {
    { _allTypes pushBackUnique _x; } forEach _configTypes;
    { _allTypes pushBackUnique _x; } forEach _missionTypes;
  };
  case 1 : {
    _allTypes append [_configTypes];
    _allTypes append [_missionTypes];
  };
  default { };
};

_allTypes;
