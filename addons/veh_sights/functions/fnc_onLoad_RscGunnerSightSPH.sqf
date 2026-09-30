#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Installs a per-frame handler that keeps the RscGunnerSightSPH gunner-sight HUD
 * updated while the player remains in the vehicle's gunner seat: current and mission
 * azimuth, current and mission quadrant, autoloader/gun status including fired/total
 * round progress, and the currently selected ammo, fuze and guidance readout. Hides
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
 * [] call itc_land_veh_sights_fnc_onLoad_RscGunnerSightSPH
 *
 * Public: No
 */

["RscGunnerSightSPH", createHashMapFromArray [
    ["group", 81001],
    ["az", 81014],
    ["misAz", 81016],
    ["qd", 81019],
    ["misQd", 81021],
    ["status", 81022],
    ["load", 81023],
    ["fuze", 81024],
    ["guidance", 81025]
]] call FUNC(runGunnerSight);
