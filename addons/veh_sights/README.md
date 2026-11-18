# Sights

`itc_land_veh_sights`: [Gunner sights](../../docs/systems/artillery.md#gunner-sight) and the optics readouts of UAVs and the Strider.

## Dependencies

- ITC: `itc_land_common`, `itc_land_datalink`
- ACE: `ace_common`, `ace_mk6mortar`

## Files

- `RscInGameUI.hpp`
- `ui/ITC_Land_RscAltGunnerSightSPH.hpp`
- `ui/ITC_Land_RscGunnerSightBasic.hpp`
- `ui/ITC_Land_RscGunnerSightMLRS.hpp`
- `ui/ITC_Land_RscGunnerSightSPH.hpp`
- `ui/ITC_Land_RscGunnerSightZamakMRLi.hpp`
- `ui/ITC_Land_RscIGS_SPH.hpp`
- `ui/ITC_Land_RscOptics_GLTD_gunner.hpp`
- `ui/ITC_Land_RscOptics_UAV_gunner.hpp`
- `ui/ITC_Land_RscOptics_strider_commander.hpp`
- `ui/ITC_Land_sightMacros.hpp`

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_drawAlignmentGuide` |  | Draws the alignment guide of the artillery sights (the controls of SIGHT_ALIGNMENT_GUIDE, IDCs 1800-1806): while a solution is selected, azimuth and quadrant marks on the crosshair within 100 mils of it, arrows beyond. |
| `fnc_getFireOrdersText` |  | Builds the six lines of the gunner sight's FCI ORDERS panel from the fire orders the FDC sent the vehicle (itc_land_bcs_fireData) and the firing line they came with: mission and ADJ/FFE, round count, round and charge, fuze (with the fuze setting for a time fuze), guidance (the target grid for a GPS round) and azimuth/quadrant. |
| `fnc_init` |  | Registers the local event handlers for each vehicle gunner-sight display's onLoad function, and adds a CBA player event handler that re-fires a vehicle's stored sight event when the player re-enters it, restoring that display's gunner-sight HUD. |
| `fnc_onLoad_RscAltGunnerSightSPH` |  | Starts the RscAltGunnerSightSPH gunner-sight HUD, the overlay over other mods' gun optics (PzH 2000, Boxer RCH 155, RHS guns). |
| `fnc_onLoad_RscGunnerSightBasic` |  | Installs a per-frame handler that keeps the RscGunnerSightBasic gunner-sight HUD updated with the current azimuth and current quadrant while the player remains in the vehicle's gunner seat. |
| `fnc_onLoad_RscGunnerSightMLRS` |  | Installs a per-frame handler that keeps the RscGunnerSightMLRS gunner-sight HUD updated while the player remains in the vehicle's gunner seat: current and mission azimuth, and current and mission quadrant. |
| `fnc_onLoad_RscGunnerSightSPH` |  | Installs a per-frame handler that keeps the RscGunnerSightSPH gunner-sight HUD updated while the player remains in the vehicle's gunner seat: current and mission azimuth, current and mission quadrant, autoloader/gun status including fired/total round progress, and the currently selected ammo, fuze and guidance readout. |
| `fnc_onLoad_RscGunnerSightZamakMRLi` |  | Installs a per-frame handler that keeps the RscGunnerSightZamakMRLi gunner-sight HUD updated while the player remains in the vehicle's gunner seat: current and mission azimuth, and current and mission quadrant (using the Zamak MRL turret's "tower_fake" animation source when computing the off-ground quadrant fallback). |
| `fnc_onLoad_RscIGS_SPH` |  | Starts the RscIGS_SPH integrated gunnery sight HUD (works for both manned turrets and UAV-controlled gunner positions). |
| `fnc_onLoad_RscOptics_GLTD_gunner` |  | Installs a per-frame handler that keeps the RscOptics_GLTD_gunner HUD updated while the player remains in the connected UAV's gunner seat: view direction (degrees and mils), the target grid and altitude under the crosshair, the UAV's own grid and altitude, the compass needle angle, and the laser status/laser code readout. |
| `fnc_onLoad_RscOptics_strider_commander` |  | Installs a per-frame handler that keeps the RscOptics_strider_commander HUD updated while the player remains in the vehicle's commander seat: view direction (degrees and mils), the target grid and altitude under the crosshair, and the vehicle's own grid and altitude, plus the compass needle angle. |
| `fnc_onLoad_RscOptics_UAV_gunner` |  | Installs a per-frame handler that keeps the RscOptics_UAV_gunner HUD updated while the player remains in the connected UAV's gunner seat: view direction (degrees and mils), the target grid and altitude under the crosshair, the UAV's own grid and altitude, and the compass needle angle. |
| `fnc_runGunnerSight` |  | Starts the per-frame handler of a gunner sight HUD and remembers it on the vehicle so the HUD is restored when the player re-enters. |
| `fnc_runOptics` |  | Starts the per-frame handler of an optics HUD (connected UAV or vehicle commander): view direction in degrees and mils, grid and altitude of the point under the crosshair and of the camera platform, the compass needle, and optionally the laser status. |
| `fnc_sendTarget` |  | "Send target to FDC" keybind: from the ITC observer optics (UAV gunner, GLTD, Strider commander) sends the target to every friendly FDC over the datalink, like a digital call for fire: the lased spot while the platform's laser is on, else the point in the centre of the view. |
