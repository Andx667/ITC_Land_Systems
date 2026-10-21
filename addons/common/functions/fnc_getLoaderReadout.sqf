#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Builds the three loader readout lines (ammo, fuze, guidance) from the settings applied in
 * the SPH ammo handler.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * ["LOAD: ...", "FUZE: ...", "GUIDANCE: ..."] <ARRAY>
 *
 * Example:
 * [_vehicle] call itc_land_common_fnc_getLoaderReadout
 *
 * Public: No
 */

params ["_vehicle"];

private _settings = _vehicle getVariable ["itc_land_sphloadersettings", []];
if (_settings isEqualTo []) exitWith {
    ["LOAD: -- N/A --", "FUZE: -- N/A --", "GUIDANCE: -- N/A --"]
};

[
    format [LLSTRING(LoaderLoad), (_settings # 0) # 0],
    format [LLSTRING(LoaderFuze), toUpper ((_settings # 1) # 0)],
    format [LLSTRING(LoaderGuidance), toUpper ((_settings # 2) # 0)]
]
