#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Starts the per-frame handler of a gunner sight HUD and remembers it on the vehicle so the
 * HUD is restored when the player re-enters. Each frame it shows the current azimuth and
 * quadrant, the azimuth and quadrant of the selected fire solution, and optionally the
 * autoloader status and loader readout. The HUD is hidden and the handler removed once the
 * player leaves the gunner seat.
 *
 * Arguments:
 * 0: Sight name, e.g. "RscGunnerSightSPH" <STRING>
 * 1: Layout <HASHMAP>
 *    "group": IDC of the control group <NUMBER>
 *    "az", "qd": IDC of the current azimuth / quadrant text <NUMBER>
 *    "azFormat", "qdFormat": format for those texts, %1 is the current and %2 the solution value (default "%1") <STRING>
 *    "misAz", "misQd": IDC of the solution azimuth / quadrant text (optional) <NUMBER>
 *    "elevationSource": animation source of the gun elevation (default "mainGun") <STRING>
 *    "status": IDC of the autoloader status text (optional) <NUMBER>
 *    "statusRounds": append round progress to the status (default true) <BOOL>
 *    "load", "fuze", "guidance": IDCs of the loader readout lines (optional) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["RscGunnerSightBasic", createHashMapFromArray [["group", 82001], ["az", 82014], ["qd", 82016]]] call itc_land_veh_sights_fnc_runGunnerSight
 *
 * Public: No
 */

params ["_sightName", "_layout"];

private _vehicle = [] call EFUNC(common,getCurVehicle);
_vehicle setVariable ["ITC_Land_SightEvent", format ["itc_land_onLoad_%1", _sightName], true];

[{
    (_this select 0) params ["_displayVar", "_layout"];
    disableSerialization;
    private _display = uiNamespace getVariable [_displayVar, displayNull];
    if (isNull _display) exitWith {};

    private _viewOk = [_display, _layout get "group", _this select 1, ACE_player call CBA_fnc_vehicleRole, "GUNNER"] call EFUNC(common,sightViewCheck);
    if (!_viewOk) exitWith {};

    private _vehicle = vehicle ACE_player;
    private _setText = {
        params ["_key", "_text"];
        private _idc = _layout getOrDefault [_key, -1];
        if (_idc >= 0) then {(_display displayCtrl _idc) ctrlSetText _text};
    };

    ([_vehicle, _layout getOrDefault ["elevationSource", "mainGun"]] call EFUNC(common,getAimAngles)) params ["_azimuth", "_quadrant"];
    private _solutionAzimuth = [_vehicle, 1] call EFUNC(common,getSolutionText);
    private _solutionQuadrant = [_vehicle, 3] call EFUNC(common,getSolutionText);

    ["az", format [_layout getOrDefault ["azFormat", "%1"], [_azimuth, 0, 4] call EFUNC(common,FormatAsMils), _solutionAzimuth]] call _setText;
    ["misAz", _solutionAzimuth] call _setText;
    ["qd", format [_layout getOrDefault ["qdFormat", "%1"], [_quadrant, 0, 4] call EFUNC(common,FormatAsMils), _solutionQuadrant]] call _setText;
    ["misQd", _solutionQuadrant] call _setText;

    if ("status" in _layout) then {
        ["status", format ["STATUS: %1", [_vehicle, _layout getOrDefault ["statusRounds", true]] call EFUNC(common,getGunStatusText)]] call _setText;
    };
    if ("load" in _layout) then {
        ([_vehicle] call EFUNC(common,getLoaderReadout)) params ["_load", "_fuze", "_guidance"];
        ["load", _load] call _setText;
        ["fuze", _fuze] call _setText;
        ["guidance", _guidance] call _setText;
    };
}, 0, ["ITC_Land_" + _sightName, _layout]] call CBA_fnc_addPerFrameHandler;
