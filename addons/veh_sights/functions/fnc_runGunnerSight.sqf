#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Starts the per-frame handler of a gunner sight HUD and remembers it on the vehicle so the
 * HUD is restored when the player re-enters. Each frame it shows the current azimuth and
 * quadrant, the azimuth and quadrant of the selected fire solution, and optionally the
 * autoloader status and loader readout and the fire orders panel. The HUD is hidden and the
 * handler removed once the player leaves the gunner seat (or the UAV gunner seat).
 * The artillery sights (IGS and the overlay for other mods' guns) use the same layout keys, so
 * they show the same information; only their look and the IGS alignment guide ("onFrame") differ.
 * The loader panel is toggled by the itc_land_IGS_showAutoloader global (default on). The orders
 * panel shows the FDC's fire orders while the vehicle has them (getFireOrdersText), and always
 * with the itc_land_IGS_showOrders global (default off).
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
 *    "loaderPanel": IDCs of the loader panel, shown with itc_land_IGS_showAutoloader (optional) <ARRAY>
 *    "orders": IDCs of the orders title, count, load, fuze, guidance and AZ/QD lines (optional) <ARRAY>
 *    "ordersPanel": IDCs of the orders panel, shown with fire orders or itc_land_IGS_showOrders (default: "orders") <ARRAY>
 *    "onFrame": code run each frame after the texts, receives [display, vehicle, azimuth, quadrant] (optional) <CODE>
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
    // the display is gone (left the seat/vehicle); its next onLoad starts a new handler
    if (isNull _display) exitWith {[_this select 1] call CBA_fnc_removePerFrameHandler};

    private _vehicle = [] call EFUNC(common,getCurVehicle);
    // The primary gunner seat counts as gunner also where it is the commander's seat too: fullCrew (and so
    // CBA_fnc_vehicleRole) calls the GTK Boxer RCH 155's only gun seat "commander"
    private _role = if (_vehicle in allUnitsUAV) then {(UAVControl _vehicle) # 1} else {[ACE_player call CBA_fnc_vehicleRole, "GUNNER"] select (gunner _vehicle == ACE_player)};
    private _viewOk = [_display, _layout get "group", _this select 1, _role, "GUNNER"] call EFUNC(common,sightViewCheck);
    if (!_viewOk) exitWith {};

    private _setText = {
        params ["_key", "_text"];
        private _idc = _layout getOrDefault [_key, -1];
        if (_idc >= 0) then {(_display displayCtrl _idc) ctrlSetText _text};
    };
    // shows or hides a panel, touching its controls only when that changes
    private _showPanel = {
        params ["_idcs", "_show"];
        private _fade = parseNumber !_show;
        if (ctrlFade (_display displayCtrl (_idcs select 0)) != _fade) then {
            {[_display, _x, _fade] call EFUNC(common,ctrlSetFade)} forEach _idcs;
        };
        _show
    };

    ([_vehicle, _layout getOrDefault ["elevationSource", "mainGun"]] call EFUNC(common,getAimAngles)) params ["_azimuth", "_quadrant"];
    private _solutionAzimuth = [_vehicle, 1] call EFUNC(common,getSolutionText);
    private _solutionQuadrant = [_vehicle, 3] call EFUNC(common,getSolutionText);

    private _milSystem = [_vehicle] call EFUNC(common,getMilSystem);
    ["az", format [_layout getOrDefault ["azFormat", "%1"], [_azimuth, 0, 4, _milSystem] call EFUNC(common,FormatAsMils), _solutionAzimuth]] call _setText;
    ["misAz", _solutionAzimuth] call _setText;
    ["qd", format [_layout getOrDefault ["qdFormat", "%1"], [_quadrant, 0, 4, _milSystem] call EFUNC(common,FormatAsMils), _solutionQuadrant]] call _setText;
    ["misQd", _solutionQuadrant] call _setText;

    if (isNil "itc_land_IGS_showAutoloader") then {itc_land_IGS_showAutoloader = true};
    private _loaderShown = if ("loaderPanel" in _layout) then {[_layout get "loaderPanel", itc_land_IGS_showAutoloader] call _showPanel} else {true};
    if (_loaderShown) then {
        if ("status" in _layout) then {
            ["status", format [LLSTRING(Status), [_vehicle, _layout getOrDefault ["statusRounds", true]] call EFUNC(common,getGunStatusText)]] call _setText;
        };
        if ("load" in _layout) then {
            ([_vehicle] call EFUNC(common,getLoaderReadout)) params ["_load", "_fuze", "_guidance"];
            ["load", _load] call _setText;
            ["fuze", _fuze] call _setText;
            ["guidance", _guidance] call _setText;
        };
    };

    if ("orders" in _layout) then {
        // shown while the FDC's fire orders are there, or always with itc_land_IGS_showOrders (placeholders without orders)
        if (isNil "itc_land_IGS_showOrders") then {itc_land_IGS_showOrders = false};
        private _fireData = _vehicle getVariable ["itc_land_bcs_fireData", []];
        if ([_layout getOrDefault ["ordersPanel", _layout get "orders"], itc_land_IGS_showOrders || {_fireData isNotEqualTo []}] call _showPanel) then {
            // the lines only change with new orders
            private _shown = _display getVariable [QGVAR(ordersShown), [nil]];
            if !(_shown isEqualTo [_vehicle, _fireData]) then {
                _display setVariable [QGVAR(ordersShown), [_vehicle, _fireData]];
                {
                    (_display displayCtrl ((_layout get "orders") select _forEachIndex)) ctrlSetText _x;
                } forEach ([_vehicle] call FUNC(getFireOrdersText));
            };
        };
    };

    if ("onFrame" in _layout) then {
        [_display, _vehicle, _azimuth, _quadrant] call (_layout get "onFrame");
    };
}, 0, ["ITC_Land_" + _sightName, _layout]] call CBA_fnc_addPerFrameHandler;
