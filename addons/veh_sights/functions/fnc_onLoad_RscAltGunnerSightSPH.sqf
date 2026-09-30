#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscAltGunnerSightSPH gunner-sight HUD
 * updated while the player remains in the vehicle's gunner seat: current and mission
 * azimuth, current and mission quadrant, autoloader/gun status, and the currently
 * selected ammo, fuze and guidance readout. Hides the control group and removes the
 * per-frame handler once the player leaves the gunner seat or camera view.
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

["RscAltGunnerSightSPH", createHashMapFromArray [
    ["group", 82001],
    ["az", 82014],
    ["azFormat", "CA: %1 MA: %2"],
    ["qd", 82016],
    ["qdFormat", "CQ: %1 MQ: %2"],
    ["status", 82020],
    ["statusRounds", false],
    ["load", 82021],
    ["fuze", 82022],
    ["guidance", 82023]
]] call FUNC(runGunnerSight);
