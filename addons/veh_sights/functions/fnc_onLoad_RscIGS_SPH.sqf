#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Starts the RscIGS_SPH integrated gunnery sight HUD (works for both manned turrets and
 * UAV-controlled gunner positions). It shows the same information as the overlay sight of other
 * mods' guns (RscAltGunnerSightSPH, see runGunnerSight): current and mission azimuth and quadrant,
 * the autoloader panel and the FCI orders panel (the FDC's fire orders). On top it has the alignment guide:
 * azimuth and quadrant marks on the crosshair within 100 mils of the selected solution, arrows
 * beyond, toggled by the itc_land_IGS_showAlignmentGuides global.
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

["RscIGS_SPH", createHashMapFromArray [
    ["group", 81001],
    ["az", 1102],
    ["misAz", 1104],
    ["qd", 1106],
    ["misQd", 1108],
    ["status", 1701],
    ["load", 1702],
    ["fuze", 1703],
    ["guidance", 1704],
    ["loaderPanel", [1700, 1701, 1702, 1703, 1704]],
    ["orders", [1600, 1601, 1602, 1603, 1604, 1605]],
    ["onFrame", {
        params ["_display", "_vehicle", "_azimuth", "_quadrant"];

        // alignment guide: where the gun points relative to the selected solution, shown while one is selected
        private _solution = [_vehicle] call EFUNC(common,getFireSolution);
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
    }]
]] call FUNC(runGunnerSight);
