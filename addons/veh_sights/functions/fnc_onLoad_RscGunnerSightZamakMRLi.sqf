#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscGunnerSightZamakMRLi gunner-sight HUD
 * updated while the player remains in the vehicle's gunner seat: current and mission
 * azimuth, and current and mission quadrant (using the Zamak MRL turret's "tower_fake"
 * animation source when computing the off-ground quadrant fallback). Hides the control
 * group and removes the per-frame handler once the player leaves the gunner seat or
 * camera view.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_veh_sights_fnc_onLoad_RscGunnerSightZamakMRLi
 *
 * Public: No
 */

["RscGunnerSightZamakMRLi", createHashMapFromArray [
    ["group", 83101],
    ["az", 83114],
    ["misAz", 83116],
    ["qd", 83119],
    ["misQd", 83121],
    ["elevationSource", "tower_fake"]
]] call FUNC(runGunnerSight);
