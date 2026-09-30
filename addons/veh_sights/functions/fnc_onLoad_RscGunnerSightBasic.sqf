#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscGunnerSightBasic gunner-sight HUD
 * updated with the current azimuth and current quadrant while the player remains in
 * the vehicle's gunner seat. Hides the control group and removes the per-frame handler
 * once the player leaves the gunner seat or camera view.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_veh_sights_fnc_onLoad_RscGunnerSightBasic
 *
 * Public: No
 */

["RscGunnerSightBasic", createHashMapFromArray [
    ["group", 82001],
    ["az", 82014],
    ["azFormat", "CUR AZ: %1"],
    ["qd", 82016],
    ["qdFormat", "CUR QD: %1"]
]] call FUNC(runGunnerSight);
