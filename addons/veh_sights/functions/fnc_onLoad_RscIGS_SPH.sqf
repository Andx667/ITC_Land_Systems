#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscIGS_SPH integrated gunnery sight HUD
 * updated while the player controls the vehicle's gunner seat (works for both manned
 * turrets and UAV-controlled gunner positions): current and mission azimuth, current
 * and mission quadrant, an optional autoloader/gun status panel (fired/total round
 * progress and current ammo/fuze/guidance readout), an optional FCI orders panel
 * (currently a placeholder), and an alignment guide (azimuth and quadrant marks on the
 * crosshair within 100 mils of the selected solution, arrows beyond). Each optional panel
 * is toggled by the itc_land_IGS_showAutoloader, itc_land_IGS_showOrders (default off)
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
    // the display is gone (left the seat/vehicle); its next onLoad starts a new handler
    if (isNull _display) exitWith {[_pfID] call CBA_fnc_removePerFrameHandler};

    private _vehicle = [] call EFUNC(common,getCurVehicle);
    // the primary gunner seat counts as gunner also where it is the commander's seat too (see runGunnerSight)
    private _role = if (_vehicle in allUnitsUAV) then {(UAVControl _vehicle) # 1} else {[ACE_player call CBA_fnc_vehicleRole, "GUNNER"] select (gunner _vehicle == ACE_player)};
    if !([_display, 81001, _pfID, _role, "GUNNER"] call EFUNC(common,sightViewCheck)) exitWith {};

    ([_vehicle] call EFUNC(common,getAimAngles)) params ["_azimuth", "_quadrant"];
    private _solution = [_vehicle] call EFUNC(common,getFireSolution);

    (_display displayCtrl 1102) ctrlSetText ([_azimuth, 0, 4] call EFUNC(common,FormatAsMils));
    (_display displayCtrl 1104) ctrlSetText ([_vehicle, 1] call EFUNC(common,getSolutionText));
    (_display displayCtrl 1106) ctrlSetText ([_quadrant, 0, 4] call EFUNC(common,FormatAsMils));
    (_display displayCtrl 1108) ctrlSetText ([_vehicle, 3] call EFUNC(common,getSolutionText));

    if (isNil "itc_land_IGS_showAutoloader") then {itc_land_IGS_showAutoloader = true};
    if (itc_land_IGS_showAutoloader) then {
        if (!(ctrlVisible 1700)) then {
            {[_display, _x, 0] call EFUNC(common,ctrlSetFade)} forEach [1700, 1701, 1702, 1703, 1704];
        };
        (_display displayCtrl 1701) ctrlSetText format [LLSTRING(Status), [_vehicle] call EFUNC(common,getGunStatusText)];
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
        (_display displayCtrl 1600) ctrlSetText LLSTRING(FciOrders);
        (_display displayCtrl 1601) ctrlSetText LLSTRING(CountNotAvailable);
        (_display displayCtrl 1602) ctrlSetText LLSTRING(LoadNotAvailable);
        (_display displayCtrl 1603) ctrlSetText LLSTRING(FuzeNotAvailable);
        (_display displayCtrl 1604) ctrlSetText LLSTRING(GuidanceNotAvailable);
        (_display displayCtrl 1605) ctrlSetText "AZ/QD: -- N/A --";
    } else {
        {[_display, _x, 1] call EFUNC(common,ctrlSetFade)} forEach [1600, 1601, 1602, 1603, 1604, 1605];
    };

    // alignment guide: where the gun points relative to the selected solution, shown while one is selected
    if (isNil "itc_land_IGS_showAlignmentGuides") then {itc_land_IGS_showAlignmentGuides = true};
    if (itc_land_IGS_showAlignmentGuides && {_solution isNotEqualTo []}) then {
        #define adjustX(ARG) ((20.4 + (ARG)) * (0.01875 * safeZoneH))
        #define adjustY(ARG) ((14.0 + (ARG)) * (0.025 * safeZoneH))
        // gun minus mission in mils, the azimuth wrapped to -3200..3200 across north. The crosshair
        // dots are 25 mils apart and its arms end at 100 mils (4.55 units across, 4.36 units up/down).
        private _azimuthDiff = ((_azimuth * 6400 / 360 - (_solution select 1)) % 6400 + 9600) % 6400 - 3200;
        private _quadrantDiff = _quadrant * 6400 / 360 - (_solution select 3);

        [_display, 1800, 0] call EFUNC(common,ctrlSetFade);

        // azimuth mark on the horizontal arm; off the scale, an arrow points the way to traverse
        private _azimuthOnScale = abs _azimuthDiff <= 100;
        [_display, 1801, parseNumber !_azimuthOnScale] call EFUNC(common,ctrlSetFade);
        if (_azimuthOnScale) then {
            (_display displayCtrl 1801) ctrlSetPosition [adjustX((_azimuthDiff / 100) * 4.55), adjustY(0)];
            (_display displayCtrl 1801) ctrlCommit 0;
        };
        [_display, 1803, parseNumber (_azimuthDiff <= 100)] call EFUNC(common,ctrlSetFade);
        [_display, 1804, parseNumber (_azimuthDiff >= -100)] call EFUNC(common,ctrlSetFade);

        // quadrant mark on the vertical arm (up = gun too high); off the scale, an arrow points the way to elevate
        private _quadrantOnScale = abs _quadrantDiff <= 100;
        [_display, 1802, parseNumber !_quadrantOnScale] call EFUNC(common,ctrlSetFade);
        if (_quadrantOnScale) then {
            (_display displayCtrl 1802) ctrlSetPosition [adjustX(0), adjustY(-(_quadrantDiff / 100) * 4.36)];
            (_display displayCtrl 1802) ctrlCommit 0;
        };
        [_display, 1805, parseNumber (_quadrantDiff >= -100)] call EFUNC(common,ctrlSetFade);
        [_display, 1806, parseNumber (_quadrantDiff <= 100)] call EFUNC(common,ctrlSetFade);
    } else {
        {[_display, _x, 1] call EFUNC(common,ctrlSetFade)} forEach [1800, 1801, 1802, 1803, 1804, 1805, 1806];
    };
}, 0, []] call CBA_fnc_addPerFrameHandler;
