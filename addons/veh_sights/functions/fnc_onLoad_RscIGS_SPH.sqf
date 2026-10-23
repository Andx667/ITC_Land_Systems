#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Starts the RscIGS_SPH integrated gunnery sight HUD (works for both manned turrets and
 * UAV-controlled gunner positions). It shows the same information as the overlay sight of other
 * mods' guns (RscAltGunnerSightSPH, see runGunnerSight): current and mission azimuth and quadrant,
 * the autoloader panel, the FCI orders panel (the FDC's fire orders) and the alignment guide
 * (see drawAlignmentGuide).
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

// a mortar has a loader, not an autoloader
if (getNumber (configOf ([] call EFUNC(common,getCurVehicle)) >> "itc_land" >> "loaderType") == 3) then {
    ((uiNamespace getVariable ["ITC_Land_RscIGS_SPH", displayNull]) displayCtrl 1700) ctrlSetText LLSTRING(controls_Loader_Text);
};

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
        [_display, _vehicle, _azimuth, _quadrant, [20.4, 14]] call FUNC(drawAlignmentGuide);
    }]
]] call FUNC(runGunnerSight);
