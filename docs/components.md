# Components

ITC follows the ACE-style addon layout: the functionality is split across several `itc_land_*` PBOs (addons), each with a single responsibility.

## Framework

| PBO | Purpose |
| --- | --- |
| `itc_land_main` | Shared macros, mod metadata, the settings category |
| `itc_land_common` | Shared functions (grid and position conversion, projectile tracking, firing solution and UI helpers) and dialog base classes |
| `itc_land_ballistics` | Ballistic tables, firing solutions and the [BCS battery types](scripting.md#battery-types) |
| `itc_land_datalink` | ID registry and messages between objects, for systems that exchange data |
| `itc_land_tablet` | The tablet items, the app framework and the [tablet apps](usage.md#tablets) |
| `itc_land_bcs` | [Battery fire missions](systems/bcs.md): target methods, sheaf patterns, per-gun solutions |
| `itc_land_veh_weapons` | Howitzer and rocket launcher weapons, [munitions](systems/artillery.md#munitions), fuzes, submunitions and the SAM-35 proximity fuze |
| `itc_land_veh_sights` | [Gunner sights](systems/artillery.md#gunner-sight) and the optics readouts of UAVs and the Strider |
| `itc_land_sphammohandler` | The [ammunition handler](systems/artillery.md#ammunition-handler) |
| `itc_land_guidance` | Laser and GPS guidance of the guided rounds |

## Systems

| PBO | Purpose |
| --- | --- |
| `itc_land_aps` | [Active protection](systems/aps.md) |
| `itc_land_ciws` | [CIWS](systems/air-defence.md#ciws) and the shell decoys they track |
| `itc_land_cobra` | [Counter-battery radar](systems/cobra.md) and sirens |
| `itc_land_vls` | [Vertical launch system](systems/air-defence.md#vertical-launch-system) and its interface |
| `itc_land_spike` | [Spike LR](systems/spike.md) |
| `itc_land_rover` | [ROVER tablet](systems/uavs.md#rover-tablet) |
| `itc_land_packable` | [Packing and unpacking](systems/uavs.md#packable-equipment) of equipment |
| `itc_land_remotefrag` | [Remote frag grenade](systems/equipment.md#remote-frag-grenade) |
| `itc_land_smokedispenser` | [Smoke dispenser](systems/equipment.md#smoke-dispenser) magazine |

## Vehicles

| PBO | Purpose |
| --- | --- |
| `itc_land_veh_sholef` | M4 Sholef 2 |
| `itc_land_veh_sochor` | 2S9 Sochor 2 |
| `itc_land_veh_hammer` | Mk45 Hammer 2 |
| `itc_land_veh_seara` | M5 Seara 2 |
| `itc_land_veh_zamakmlr` | Zamak MRLi |
| `itc_land_veh_mk6` | Mk6 mortar magazines for the BCS |
| `itc_land_veh_defender` | MIM-145 Defender 2 |
| `itc_land_veh_rhea` | S750 Rhea 2 |
| `itc_land_veh_gltd` | Remote GLTD |
| `itc_land_veh_strider` | Strider RV |
| `itc_land_veh_uav01` | AR-2i and AR-2e, UAV bags |
| `itc_land_veh_uav02` | MQ-4I Greyhawk, K40i Ababil-3 |
| `itc_land_veh_uav05` | UCAVi Sentinel 2 |
| `itc_land_veh_uav06` | AL-6 Pelican packing, UAV bags (AL-6) |

## Compatibility

These PBOs ship with the mod and load only when the other mod is loaded too (`skipWhenMissingDependencies`); without it they are skipped silently.

Other mods' 82 mm mortars that use the vanilla `mortar_82mm` and its rounds (the CUP 2B14, M252, L16A2 and FV432 mortar, for example) need no compatibility PBO: the BCS's Mk6 battery type covers them.

| PBO | Needs | Purpose |
| --- | --- | --- |
| `itc_land_compat_rhs_afrf` | RHS: AFRF | ITC versions of the 2S1 Gvozdika and 2S3 Akatsiya (ammunition handler, mounted tablet, ITC sight), ITC sights for the D-30, firing tables and BCS battery types for the D-30 and the 2B14 Podnos mortar (the old ITC 2B14 stays hidden for old missions) |
| `itc_land_compat_rhs_usaf` | RHS: USAF | ITC versions of the M109A6 Paladin (ammunition handler, mounted tablet, ITC sight), ITC sights for the M119A2, firing tables and BCS battery types for the M119A2 and the M252 mortar (the old ITC M252 stays hidden for old missions) |
| `itc_land_compat_bwa3` | BWMod | ITC versions of the Panzerhaubitze 2000 (ammunition handler, mounted tablet, ITC sight, ITC 155 mm L/52 rounds with German designations), firing tables and a BCS battery type for the MRS120 mortar |
| `itc_land_compat_cup_units` | CUP Units (and CUP Weapons) | ITC versions of the D-30 and M119 (ITC sight, no vanilla artillery computer), firing tables and BCS battery types for both |
| `itc_land_compat_cup_vehicles` | CUP Vehicles | ITC versions of the M270 MLRS (ITC 230 mm rockets, MLRS sight and mounted tablet, like the Seara 2) and of the M1129 Stryker mortar carrier (ITC 120 mm mortar rounds, ITC sight, firing tables and BCS battery type) |
