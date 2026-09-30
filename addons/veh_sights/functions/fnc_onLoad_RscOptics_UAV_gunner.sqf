#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscOptics_UAV_gunner HUD updated while
 * the player remains in the connected UAV's gunner seat: view direction (degrees and
 * mils), the target grid and altitude under the crosshair, the UAV's own grid and
 * altitude, and the compass needle angle. Hides the control group and removes the
 * per-frame handler once the player leaves the gunner seat or camera view.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_veh_sights_fnc_onLoad_RscOptics_UAV_gunner
 *
 * Public: No
 */

["RscOptics_UAV_gunner", createHashMapFromArray [
    ["uav", true],
    ["role", "GUNNER"],
    ["dirDigits", 3],
    ["combined", false],
    ["laser", false]
]] call FUNC(runOptics);
