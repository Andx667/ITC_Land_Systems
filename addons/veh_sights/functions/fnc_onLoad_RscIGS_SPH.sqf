#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscIGS_SPH integrated gunnery sight HUD
 * updated while the player controls the vehicle's gunner seat (works for both manned
 * turrets and UAV-controlled gunner positions): current and mission azimuth, current
 * and mission quadrant, an optional autoloader/gun status panel (fired/total round
 * progress and current ammo/fuze/guidance readout), an optional FCI orders panel
 * (currently a placeholder), and an optional azimuth-alignment guide indicator. Each
 * optional panel is toggled by the itc_land_IGS_showAutoloader, itc_land_IGS_showOrders
 * and itc_land_IGS_showAlignmentGuides globals. Hides the control group and removes the
 * per-frame handler once the player leaves the gunner seat or camera view.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_veh_sights_fnc_onLoad_RscIGS_SPH
 *
 * Public: No
 */

private _vehicle = [] call EFUNC(common,getCurVehicle);
_vehicle setVariable ["ITC_Land_SightEvent", "itc_land_onLoad_RscIGS_SPH", true];

[{
    params ["_args", "_pfID"];
    disableSerialization;
    private _display = uiNamespace getVariable ["ITC_Land_RscIGS_SPH", displayNull];
    if (isNull _display) exitWith {};

    private _vehicle = [] call EFUNC(common,getCurVehicle);
    private _role = if (_vehicle in allUnitsUAV) then {(UAVControl _vehicle) # 1} else {ACE_player call CBA_fnc_vehicleRole};
    if !([_display, 81001, _pfID, _role, "GUNNER"] call EFUNC(common,sightViewCheck)) exitWith {};

    ([_vehicle] call EFUNC(common,getAimAngles)) params ["_azimuth", "_quadrant"];
    private _solution = [_vehicle] call EFUNC(common,getFireSolution);
    private _solutionAzimuth = if (_solution isEqualTo []) then {_azimuth} else {_solution select 1};

    (_display displayCtrl 1102) ctrlSetText ([_azimuth, 0, 4] call EFUNC(common,FormatAsMils));
    (_display displayCtrl 1104) ctrlSetText ([_vehicle, 1] call EFUNC(common,getSolutionText));
    (_display displayCtrl 1106) ctrlSetText ([_quadrant, 0, 4] call EFUNC(common,FormatAsMils));
    (_display displayCtrl 1108) ctrlSetText ([_vehicle, 3] call EFUNC(common,getSolutionText));

    if (isNil "itc_land_IGS_showAutoloader") then {itc_land_IGS_showAutoloader = true};
    if (itc_land_IGS_showAutoloader) then {
        if (!(ctrlVisible 1700)) then {
            {[_display, _x, 0] call EFUNC(common,ctrlSetFade)} forEach [1700, 1701, 1702, 1703, 1704];
        };
        (_display displayCtrl 1701) ctrlSetText format ["STATUS: %1", [_vehicle] call EFUNC(common,getGunStatusText)];
        ([_vehicle] call EFUNC(common,getLoaderReadout)) params ["_load", "_fuze", "_guidance"];
        (_display displayCtrl 1702) ctrlSetText _load;
        (_display displayCtrl 1703) ctrlSetText _fuze;
        (_display displayCtrl 1704) ctrlSetText _guidance;
    } else {
        {[_display, _x, 1] call EFUNC(common,ctrlSetFade)} forEach [1700, 1701, 1702, 1703, 1704];
    };

    if (isNil "itc_land_IGS_showOrders") then {itc_land_IGS_showOrders = false};
    if (itc_land_IGS_showOrders) then {
        if (!(ctrlVisible 1600)) then {
            {[_display, _x, 0] call EFUNC(common,ctrlSetFade)} forEach [1600, 1601, 1602, 1603, 1604, 1605];
        };
        // fire orders are not implemented yet, so the panel only shows placeholders
        (_display displayCtrl 1600) ctrlSetText "FCI ORDERS";
        (_display displayCtrl 1601) ctrlSetText "COUNT: -- N/A --";
        (_display displayCtrl 1602) ctrlSetText "LOAD: -- N/A --";
        (_display displayCtrl 1603) ctrlSetText "FUZE: -- N/A --";
        (_display displayCtrl 1604) ctrlSetText "GUIDANCE: -- N/A --";
        (_display displayCtrl 1605) ctrlSetText "AZ/QD: -- N/A --";
    } else {
        {[_display, _x, 1] call EFUNC(common,ctrlSetFade)} forEach [1600, 1601, 1602, 1603, 1604, 1605];
    };

    if (isNil "itc_land_IGS_showAlignmentGuides") then {itc_land_IGS_showAlignmentGuides = false};
    if (itc_land_IGS_showAlignmentGuides) then {
        if (!(ctrlVisible 1800)) then {
            {[_display, _x, 0] call EFUNC(common,ctrlSetFade)} forEach [1800, 1801, 1802];
        };
        #define adjustX(ARG) ((20.4 + (ARG)) * (0.01875 * safeZoneH))
        #define adjustY(ARG) ((14.0 + (ARG)) * (0.025 * safeZoneH))
        private _azimuthDiff = _azimuth - _solutionAzimuth;
        if ((_azimuthDiff <= 100) && (_azimuthDiff >= -100)) then {
            [_display, 1801, 0] call EFUNC(common,ctrlSetFade);
            (_display displayCtrl 1801) ctrlSetPosition [adjustX((_azimuthDiff / 100) * 4.55), adjustY(0)];
            (_display displayCtrl 1801) ctrlCommit 0;
        } else {
            [_display, 1801, 1] call EFUNC(common,ctrlSetFade);
        };
    } else {
        {[_display, _x, 1] call EFUNC(common,ctrlSetFade)} forEach [1800, 1801, 1802, 1803, 1804, 1805, 1806];
    };
}, 0, []] call CBA_fnc_addPerFrameHandler;
