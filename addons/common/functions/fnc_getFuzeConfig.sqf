#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The fuze config of a magazine (ITC_Land_CfgFuzes, named by the magazine's itc_land_fuze):
 * its "modes" and their names in "modeDesc".
 *
 * Arguments:
 * 0: Magazine class name <STRING>
 *
 * Return Value:
 * Fuze config, configNull for a magazine without an ITC fuze <CONFIG>
 *
 * Example:
 * getArray (["itc_land_155mm_HE"] call itc_land_common_fnc_getFuzeConfig >> "modes")
 *
 * Public: No
 */

params ["_magazine"];

configFile >> "ITC_Land_CfgFuzes" >> getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_fuze")
