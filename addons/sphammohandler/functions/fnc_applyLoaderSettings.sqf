#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Applies the ammunition handler's settings, the ones the loader works with: the prepared round
 * (itc_land_currentMagInfo) with its charge, the selected fuze mode (common_fnc_setFuzeSelection)
 * with its setting, the guidance (GPS target or laser codes) and the round count, stored on the
 * vehicle as itc_land_sphloadersettings. The ammunition handler is then ready to load.
 * A laser code that is none is replaced by 1111; the page shows the codes the vehicle keeps
 * (itc_land_guidance_laserCode / _2). A mortar has no round count: its crew fires every round by hand.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Fuze time (s) <NUMBER>
 * 2: Laser codes, first and second <ARRAY of NUMBERs>
 * 3: GPS target grid <STRING>
 * 4: GPS target altitude (m ASL) <NUMBER>
 * 5: Round count <NUMBER>
 *
 * Return Value:
 * Settings: [[round text, magazine, charge, count], [fuze text, mode, values], [guidance text, guidance]] <ARRAY>
 *
 * Example:
 * [_vehicle, 0, [1111, 1112], "", 0, 3] call itc_land_sphammohandler_fnc_applyLoaderSettings
 *
 * Public: No
 */

params ["_vehicle", "_fuzeTime", "_laserCodes", "_targetGrid", "_targetAlt", "_roundCount"];

_vehicle setVariable ["itc_land_ammoHandler_status", [1, 0, LSTRING(Status_Waiting)], true];

private _magazine = (_vehicle getVariable ["itc_land_currentMagInfo", [0, ""]]) param [1, ""];
private _magazineConfig = configFile >> "CfgMagazines" >> _magazine;
private _charge = _vehicle getVariable ["itc_land_currentChargeIndex", 1];
private _ammoText = format [LLSTRING(AmmoCharge), getText (_magazineConfig >> "displayNameShort"), _charge];

private _fuzeMode = _vehicle getVariable ["itc_land_selectedFuzeMode", "pd"];
private _fuzeDesc = _vehicle getVariable ["itc_land_selectedFuzeDesc", ""];
([_vehicle, _fuzeMode, _fuzeDesc, getText (_magazineConfig >> "itc_land_fuze"), _fuzeTime, "itc_land_fuzeTime"] call EFUNC(common,resolveFuzeSetting)) params ["_fuzeText", "_fuzeValues"];

_laserCodes = _laserCodes apply {[1111, _x] select ([_x] call EFUNC(common,isLaserCode))};
_laserCodes params ["_laserCode", "_laserCode2"];
private _guidance = (getArray (_magazineConfig >> "itc_land_guidance")) param [0, ""];
private _guidanceText = "-- N/A --";
switch (_guidance) do {
    case "gps_inertial": {
        [_vehicle, _targetGrid, _targetAlt] call EFUNC(common,setGpsTarget);
        _guidanceText = format ["%1 -- %2", _targetGrid, _targetAlt];
    };
    case "laser_coded": {
        _vehicle setVariable ["itc_land_guidance_laserCode", _laserCode, true];
        _guidanceText = format [LLSTRING(LaserCode), _laserCode];
    };
    case "laser_coded_2": {
        _vehicle setVariable ["itc_land_guidance_laserCode", _laserCode, true];
        _vehicle setVariable ["itc_land_guidance_laserCode_2", _laserCode2, true];
        _guidanceText = format [LLSTRING(LaserCodes), _laserCode, _laserCode2];
    };
};

if (getNumber (configOf _vehicle >> "itc_land" >> "loaderType") == 3) then {_roundCount = 0};
_vehicle setVariable ["itc_land_roundCount", _roundCount, true];
_vehicle setVariable ["itc_land_roundsFired", 0, true];

private _settings = [
    [_ammoText, _magazine, _charge, _roundCount],
    [_fuzeText, _fuzeMode, _fuzeValues],
    [_guidanceText, _guidance]
];
_vehicle setVariable ["itc_land_sphloadersettings", _settings, true];
_settings
