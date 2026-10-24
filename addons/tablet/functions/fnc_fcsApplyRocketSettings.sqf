#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The MLRS FCI's APPLY: the fuze mode and setting of the rockets (common_fnc_setFuzeSelection,
 * common_fnc_resolveFuzeSetting) and the target of a GPS guided rocket.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Rocket, magazine class name <STRING>
 * 2: Fuze mode index <NUMBER>
 * 3: Fuze time (s) <NUMBER>
 * 4: GPS target grid <STRING>
 * 5: GPS target altitude (m ASL) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player, "itc_land_227mm_GMLRS", 0, 0, "0123456789", 120] call itc_land_tablet_fnc_fcsApplyRocketSettings
 *
 * Public: No
 */

params ["_vehicle", "_round", "_fuzeIndex", "_fuzeTime", "_targetGrid", "_targetAlt"];

if (_round == "") exitWith {};
private _mode = [_vehicle, _round, _fuzeIndex] call EFUNC(common,setFuzeSelection);
[_vehicle, _mode, _vehicle getVariable ["itc_land_selectedFuzeDesc", ""], getText (configFile >> "CfgMagazines" >> _round >> "itc_land_fuze"), _fuzeTime, "itc_land_mlrsfci_fuzeTime"] call EFUNC(common,resolveFuzeSetting);

if ((getArray (configFile >> "CfgMagazines" >> _round >> "itc_land_guidance")) param [0, ""] == "gps_inertial") then {
    [_vehicle, _targetGrid, _targetAlt] call EFUNC(common,setGpsTarget);
};
