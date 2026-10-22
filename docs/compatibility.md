# Compatibility with other mods

ITC Land Systems brings its fire control to the artillery of RHS, CUP and BWMod. The compatibility is part of the mod: there is nothing extra to download, and each part switches itself on only when the other mod is loaded. Without that mod it is skipped silently.

The ITC versions are separate vehicles next to the originals, in the same factions, with **mod. 0** in their names (e.g. **2S1 mod. 0 Gvozdika 2**). The original vehicles of the other mod stay as they are.

## What the ITC versions add

| Kind | What changes | Works like |
| --- | --- | --- |
| **Self-propelled guns** (2S1, 2S3, M109A6, Panzerhaubitze 2000) | [Ammunition handler](systems/artillery.md#ammunition-handler) with ITC rounds, fuzes and charges, mounted tablet for the commander with firing solutions, ITC gunner sight, vanilla artillery computer off | Sholef 2, Sochor 2 |
| **Rocket launcher** (M270 MLRS) | ITC 230 mm rockets (ICM, guided, mines, ...), mounted tablet for the gunner, ITC MLRS sight, vanilla artillery computer off | Seara 2 |
| **Towed guns** (D-30, M119) and the **M1129 mortar carrier** | ITC gunner sight, firing tables for the [BCS](systems/bcs.md), vanilla artillery computer off. The towed guns keep their own rounds. | — |

For these, the BCS lists the charges with the same names as the gun's fire modes, so you select the charge the solution names.

## Mortars

Stationary mortars get no ITC version: ACE already covers them with range tables and crew served weapons. What ITC adds is the [BCS](systems/bcs.md): the rounds of these mortars carry firing tables and have a battery type, so the BCS computes fire missions for the original mortars, also across several of them.

| Mortar | BCS battery type |
| --- | --- |
| RHS 2B14 'Podnos' | 2B14 - 82mm Mortar |
| RHS M252 | M252 - 81mm Mortar (RHS M821 rounds only: the vanilla 82 mm rounds it can also fire have tables for the Mk6's three charges, not the M252's five) |
| BWMod MRS120 | MRS120 - 120mm Mortar |
| Vanilla Mk6, CUP 2B14, M252, L16A2, FV432 mortar carrier and Hilux mortar | Mk6 (they all fire the vanilla 82 mm rounds) |

## RHS: AFRF

| Vehicle | Classnames | Rounds | BCS battery type |
| --- | --- | --- | --- |
| **2S1 mod. 0 Gvozdika 2** | `itc_land_rhsafrf_2s1_tv`, `itc_land_rhsafrf_2s1_vmf` | ITC 122 mm: HE, smoke, laser guided, illumination | 2A31 - 122mm Howitzer |
| **2S3 mod. 0 Akatsiya 2** | `itc_land_rhsafrf_2s3_tv` | ITC 152 mm: HE, smoke, ICM, laser guided, illumination | 2A33 - 152mm Howitzer |
| **D-30 mod. 0** | `itc_land_rhsafrf_d30_msv`, `_vdv`, `_vmf`, `_ins` | RHS 122 mm (OF-462, 3OF56, D-462, S-463, 3OF69M) | 2A18M (D-30) - 122mm Howitzer |

## RHS: USAF

| Vehicle | Classnames | Rounds | BCS battery type |
| --- | --- | --- | --- |
| **M109A6 mod. 0 Paladin 2** | `itc_land_rhsusf_m109_usarmy` (woodland), `itc_land_rhsusf_m109d_usarmy` (desert) | ITC 155 mm: HE, smoke, ICM, AT and AP mines, GPS and laser guided, illumination | M109A6 - 155mm Howitzer |
| **M119A2 mod. 0** | `itc_land_rhsusf_m119_d`, `itc_land_rhsusf_m119_wd` | RHS 105 mm (HE, illumination, smoke) | M119 - 105mm Howitzer |

## CUP

| Vehicle | Classnames | Rounds | BCS battery type |
| --- | --- | --- | --- |
| **D-30 mod. 0** | `itc_land_cup_d30_` + `afu`, `cdf`, `tk_gue`, `chdkz`, `ru`, `rus_m_desert`, `rus_m_summer`, `rus_m_winter`, `sla`, `tk`, `tk_ins` | CUP 122 mm: HE, WP, laser guided, smoke, illumination | D-30 - 122mm Howitzer (CUP) |
| **M119 mod. 0** | `itc_land_cup_m119_` + `hil`, `us`, `usmc`, `racs` | CUP 105 mm: HE, WP, laser guided, smoke, illumination | M119 - 105mm Howitzer (CUP) |
| **M270 MLRS mod. 0** | `itc_land_cup_m270_` + `baf_des`, `baf_wood`, `hil`, `usa`, `usmc`, `aaf`, `racs` | ITC 230 mm rockets | M230 (as the Seara 2) |
| **M1129 Mortar Carrier mod. 0** (Stryker) | `itc_land_cup_m1129_desert`, `itc_land_cup_m1129_woodland` | M934 120mm HE (`itc_land_cup_m121_he`), M929 120mm Smoke (`itc_land_cup_m121_smoke`) | M121 - 120mm Mortar (CUP) |

The D-30 and M119 need CUP Units (with CUP Weapons), the M270 and M1129 need CUP Vehicles. The D-30's anti-tank round fires directly and has no firing tables.

CUP's own M1129 fires the vanilla ship cannon round, which is a 155 mm shell. The ITC M1129 fires a 120 mm mortar shell instead (`itc_land_120mm_mortar`, part of the mod's ammunition: less damage and a smaller radius than the 155 mm, more than the 82 mm). CUP's M1129 and its rounds stay unchanged.

## BWMod

| Vehicle | Classnames | Rounds | BCS battery type |
| --- | --- | --- | --- |
| **ITC Panzerhaubitze 2000** | `itc_land_bwa3_pzh2000` (Fleck), `itc_land_bwa3_pzh2000d` (Tropen) | ITC 155 mm L/52 with German designations: DM121 HE, DM125 smoke, DM106 illumination, M718 AT mines, DM702 GPS and laser guided | PzH2000 - 155mm Howitzer |

The Panzerhaubitze 2000 fires with the same ballistics as the Sholef 2 (155 mm L/52). Like the real gun it loads automatically, about 5 s per round.

## Moving from the old compatibility mods

The standalone **ITC Land Systems - RHS AFRF Compatibility** and **RHS USAF Compatibility** mods and the ITC Panzerhaubitze 2000 of the TTT mod are replaced by the above. Unload them: if both are loaded they define the same vehicles, and whichever loads last wins.

Missions made with them keep working. The vehicle, weapon and magazine classnames are unchanged, and the addon names of the old RHS mods still exist, so missions that list them still load. The ITC mortars of the old RHS mods (`itc_land_rhsafrf_2b14_*`, `itc_land_rhsusf_m252_*` and their bags) stay for those missions, hidden in Eden, Zeus and the Arsenal.

## Known limits

- **ACE advanced assembly** (ACE crew served weapons, off by default): with it on, packing one of the hidden ITC 2B14 or M252 from an old mission gives ACE's carry items, and those assemble the RHS original.
- **CUP M119** depresses to -20°, the firing tables start at -9°: targets that need more depression get no solution.
- **Not covered:** the CUP BM-21 Grad and RM-70 (their rockets' flight is not verified yet), the Hilux rocket technicals and the CUP frigate's gun. They keep the vanilla artillery computer.

## For developers

The compatibility addons are `addons/compat_rhs_afrf`, `compat_rhs_usaf`, `compat_cup_units`, `compat_cup_vehicles` and `compat_bwa3` (see [Components](components.md#compatibility)). Each sets `skipWhenMissingDependencies = 1` and lists the other mod's addons in `requiredAddons`.

`.hemtt/launch.toml` has a profile per mod, to chain after another profile:

```cmd
hemtt launch default rhs        & rem RHS: AFRF and USAF (rhs_afrf / rhs_usaf for one of them)
hemtt launch default cup        & rem CUP Weapons, Units and Vehicles
hemtt launch default bwa3       & rem BWMod
hemtt launch server rhs         & rem works with the multiplayer profiles too
```

Firing tables for guns with their own charges are generated with the same method as the in-game table generator (`ballistics/functions/tables/calcBallistics.sqf`); guns that share the vanilla AMOS charges (M119, D-30) use the shared `ballistics/tables/b_155` tables.
