#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscOptics_strider_commander HUD updated
 * while the player remains in the vehicle's commander seat: view direction (degrees
 * and mils), the target grid and altitude under the crosshair, and the vehicle's own
 * grid and altitude, plus the compass needle angle. Hides the control group and
 * removes the per-frame handler once the player leaves the commander seat or camera
 * view.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_veh_sights_fnc_onLoad_RscOptics_strider_commander
 *
 * Public: No
 */

["RscOptics_strider_commander", createHashMapFromArray [
    ["uav", false],
    ["role", "commander"],
    ["dirDigits", 4],
    ["combined", true],
    ["laser", false]
]] call FUNC(runOptics);
