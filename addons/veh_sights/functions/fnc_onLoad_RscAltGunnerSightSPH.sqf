#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Starts the RscAltGunnerSightSPH gunner-sight HUD, the overlay over other mods' gun optics
 * (PzH 2000, Boxer RCH 155, RHS guns). It shows the same information as the IGS of the ITC guns
 * (see runGunnerSight): current and mission azimuth and quadrant, heading and laser range,
 * the autoloader panel and the FCI orders panel (the FDC's fire orders); only the IGS alignment guide
 * is left out, the host mod's reticle stays.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_veh_sights_fnc_onLoad_RscAltGunnerSightSPH
 *
 * Public: No
 */

// a mortar has a loader, not an autoloader
if (getNumber (configOf ([] call EFUNC(common,getCurVehicle)) >> "itc_land" >> "loaderType") == 3) then {
    ((uiNamespace getVariable ["ITC_Land_RscAltGunnerSightSPH", displayNull]) displayCtrl 82019) ctrlSetText LLSTRING(Loader_Text);
};

["RscAltGunnerSightSPH", createHashMapFromArray [
    ["group", 82001],
    ["az", 82014],
    ["azFormat", "CA: %1 MA: %2"],
    ["qd", 82016],
    ["qdFormat", "CQ: %1 MQ: %2"],
    ["status", 82020],
    ["load", 82021],
    ["fuze", 82022],
    ["guidance", 82023],
    ["loaderPanel", [82017, 82018, 82019, 82020, 82021, 82022, 82023]],
    SIGHT_ORDERS_LAYOUT
]] call FUNC(runGunnerSight);
