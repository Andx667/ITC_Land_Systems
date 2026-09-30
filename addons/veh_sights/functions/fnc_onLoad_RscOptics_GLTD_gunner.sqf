#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscOptics_GLTD_gunner HUD updated while
 * the player remains in the connected UAV's gunner seat: view direction (degrees and
 * mils), the target grid and altitude under the crosshair, the UAV's own grid and
 * altitude, the compass needle angle, and the laser status/laser code readout. Hides
 * the control group and removes the per-frame handler once the player leaves the
 * gunner seat or camera view.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_veh_sights_fnc_onLoad_RscOptics_GLTD_gunner
 *
 * Public: No
 */

["RscOptics_GLTD_gunner", createHashMapFromArray [
    ["uav", true],
    ["role", "GUNNER"],
    ["dirDigits", 4],
    ["combined", true],
    ["laser", true]
]] call FUNC(runOptics);
