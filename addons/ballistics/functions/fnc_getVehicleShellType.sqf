#include "..\script_component.hpp"

/*
 *
 *
 *
 */
params ["_vehicle"];

_hasFCS = isClass (configOf _vehicle >> "itc_land" >> "fcs");
if(!_hasFCS) exitWith {};

_tableListFile = (configOf _vehicle >> "itc_land" >> "fcs" >> "tableList")  call BIS_fnc_getCfgData;
_tableListFile
