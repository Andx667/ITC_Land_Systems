#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Draws the alignment guide of the artillery sights (the controls of SIGHT_ALIGNMENT_GUIDE, IDCs
 * 1800-1806): while a solution is selected, azimuth and quadrant marks on the crosshair within
 * 100 mils of it, arrows beyond. Hidden without a solution or with the
 * itc_land_IGS_showAlignmentGuides global off.
 *
 * Arguments:
 * 0: Sight display <DISPLAY>
 * 1: Vehicle <OBJECT>
 * 2: Gun azimuth in degrees <NUMBER>
 * 3: Gun quadrant in degrees <NUMBER>
 * 4: Position of the marks in the sight's group units, as given to SIGHT_ALIGNMENT_GUIDE <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display, _vehicle, _azimuth, _quadrant, [20.4, 14]] call itc_land_veh_sights_fnc_drawAlignmentGuide
 *
 * Public: No
 */

params ["_display", "_vehicle", "_azimuth", "_quadrant", "_origin"];
_origin params ["_originX", "_originY"];

// where the gun points relative to the selected solution, shown while one is selected
private _solution = [_vehicle] call EFUNC(common,getFireSolution);
if (isNil "itc_land_IGS_showAlignmentGuides") then {itc_land_IGS_showAlignmentGuides = true};
if !(itc_land_IGS_showAlignmentGuides && {_solution isNotEqualTo []}) exitWith {
    {[_display, _x, 1] call EFUNC(common,ctrlSetFade)} forEach [1800, 1801, 1802, 1803, 1804, 1805, 1806];
};

#define adjustX(ARG) ((_originX + (ARG)) * (0.01875 * safeZoneH))
#define adjustY(ARG) ((_originY + (ARG)) * (0.025 * safeZoneH))
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
