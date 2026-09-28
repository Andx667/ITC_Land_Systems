#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Returns the ballistic table list file path defined in the vehicle's fire control system config (CfgVehicles >> itc_land >> fcs >> tableList),
 * used to determine which ballistic tables are available for that vehicle. Exits with no return value if the vehicle has no FCS config class.
 *
 * Arguments:
 * 0: Vehicle to query <OBJECT>
 *
 * Return Value:
 * Path to the vehicle's ballistic table list file <STRING>
 *
 * Example:
 * [vehicle player] call itc_land_ballistics_fnc_getVehicleShellType
 *
 * Public: No
 */
params ["_vehicle"];

_hasFCS = isClass (configOf _vehicle >> "itc_land" >> "fcs");
if(!_hasFCS) exitWith {};

_tableListFile = (configOf _vehicle >> "itc_land" >> "fcs" >> "tableList")  call BIS_fnc_getCfgData;
_tableListFile
