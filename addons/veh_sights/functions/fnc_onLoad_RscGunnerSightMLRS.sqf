#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscGunnerSightMLRS gunner-sight HUD
 * updated while the player remains in the vehicle's gunner seat: current and mission
 * azimuth, and current and mission quadrant. Hides the control group and removes the
 * per-frame handler once the player leaves the gunner seat or camera view.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_veh_sights_fnc_onLoad_RscGunnerSightMLRS
 *
 * Public: No
 */

["RscGunnerSightMLRS", createHashMapFromArray [
    ["group", 83001],
    ["az", 83014],
    ["misAz", 83016],
    ["qd", 83019],
    ["misQd", 83021]
]] call FUNC(runGunnerSight);
