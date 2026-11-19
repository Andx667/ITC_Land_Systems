# Systems

Every system of ITC with its vehicles and items. Classnames are given for mission makers; the editor and Zeus names are in **bold**. Below the table are the interactions, tablets and settings the systems share.

| Page | Addons | What it covers |
| --- | --- | --- |
| [Artillery & Fire Control](artillery.md) | `itc_land_veh_sholef`, `itc_land_veh_sochor`, `itc_land_veh_hammer`, `itc_land_veh_seara`, `itc_land_veh_zamakmlr`, `itc_land_veh_weapons`, `itc_land_veh_sights`, `itc_land_sphammohandler`, `itc_land_ballistics`, `itc_land_guidance` | Self-propelled guns, naval gun, rocket launchers, munitions and fuzes, firing solutions, gunner sights, ammunition handler |
| [Battery Computer (BCS)](bcs.md) | `itc_land_bcs`, `itc_land_tablet` | Fire missions with a whole battery from the tablet |
| [Counter-Battery Radar](cobra.md) | `itc_land_cobra` | COBRA radars, impact prediction, firing positions, sirens |
| [Air & Missile Defence](air-defence.md) | `itc_land_ciws`, `itc_land_veh_defender`, `itc_land_veh_rhea`, `itc_land_vls` | CIWS, SAM sites, vertical launch system |
| [UAVs & Recon](uavs.md) | `itc_land_veh_uav01`, `itc_land_veh_uav02`, `itc_land_veh_uav05`, `itc_land_veh_uav06`, `itc_land_packable`, `itc_land_veh_gltd`, `itc_land_rover`, `itc_land_veh_strider`, `itc_land_veh_nyx` | UAVs, packable equipment, remote laser designator, ROVER tablet, Strider RV |

## Interactions

Most ITC actions are in the ACE interaction menu:

- **Self interaction** (hold ++ctrl+left-windows++) → **Equipment**: open a handheld tablet, unpack packed equipment
- **Self interaction inside a vehicle**: open the mounted tablet, the ammunition handler or the VLS interface
- **Interaction** (hold ++left-windows++) on a deployed UAV or laser designator: **Repack**

| Action | Where | Who |
| --- | --- | --- |
| **FDC Tablet** | Self interaction → Equipment | You carry the tablet |
| **Open Rover LAD** | Self interaction → Equipment | You carry the ROVER tablet |
| **Unpack** → item | Self interaction → Equipment | You carry a packed UAV or GLTD |
| **Repack UAV**, **Repack GLTD** | Interaction on the deployed object | Within 3 m |
| **Open Mounted Tablet** | Self interaction in Sholef 2, Sochor 2 | Commander |
| **Open Mounted Tablet** | Self interaction in Seara 2, Zamak MRLi | Gunner |
| **Open Mounted Tablet** | Self interaction in Hammer 2 | Any crew seat |
| **Open Ammo Handling Interface** | Self interaction in Sholef 2, Sochor 2 | Gunner |
| **Open Ammo Handling Interface** | Self interaction in Hammer 2 | Any crew seat |
| **Open VLS Interface** | Self interaction in the MN230 VLS (Cruise Missile) | Any crew seat |
| **Send target to FDC** (key, ++ctrl+shift+t++) | In the ITC optics of a UAV, the GLTD, the Strider or the Nyx | Observer ([details](uavs.md#sending-a-target-to-the-fdc)) |

## Tablets

The tablets run apps. Which apps a tablet has depends on the tablet:

| Tablet | Item | Apps |
| --- | --- | --- |
| FDC Tablet (Fire Direction Tablet) | `itc_land_tablet_fdc` | [Battery Control System](bcs.md), [Counter Battery Radar](cobra.md#counter-battery-radar-app) |
| SPG tablet (mounted only) | `itc_land_tablet_spg` | [Self Propelled Gun](artillery.md#fire-control-on-the-tablet), [Battery Control System](bcs.md) |
| MLRS tablet (mounted only) | `itc_land_tablet_mlrs` | [Guided Missile Configuration](artillery.md#rocket-artillery), [Battery Control System](bcs.md) |
| Rover LAD Tablet | `itc_land_tablet_rover` | [ROVER video feed](uavs.md#rover-tablet) |

The vehicles carry a **mounted tablet**: the SPG tablet in the Sholef 2, Sochor 2 and Hammer 2, the MLRS tablet in the Seara 2 and Zamak MRLi. The mounted tablet works on the vehicle you sit in. Only the FDC and ROVER tablets are carried as items.

## Settings

Under **Addon Options → ITC Land Systems Redux** (CBA settings):

| Category | Setting | Default | Scope |
| --- | --- | --- | --- |
| CIWS | **Enable CIWS** — [CIWS](air-defence.md#ciws) turrets track and shoot down incoming artillery, mortar and rocket rounds | On | Server-wide |
| COBRA Counter-Battery Radar | **Detection range** — maximum distance at which a [COBRA](cobra.md) detects incoming rounds | 10 000 m (1 000–20 000) | Server-wide |
| COBRA Counter-Battery Radar | **Engagement window** — seconds after the last detected shot during which new shots from within 300 m are added to the same engagement | 30 s (5–300) | Server-wide |
| Debug | **Debug overlay** — shows the state of the ITC systems as text above vehicles and units, with lines between linked systems; see [Debugging](../scripting.md#debugging). For testing: it shows things a player would not know | Off | Each player |
| Fire control | **Russian guns in 6000 mils** — the Russian guns (Sochor 2, 2S1, 2S3, D-30, 2B14) and their BCS batteries show angles in the Russian 6000 mil system, written `15-00`, and the BCS reads those batteries' mil inputs (OT and sheaf direction) in it; off: NATO 6400 mils everywhere | On | Server-wide |
| Tablet | **Tablet in HTML** — the tablets and the ammunition handler open as web pages (Arma 3 2.20 browser control) with the same apps and settings; **CLASSIC TABLET** on the tablet's home screen opens the classic one; off: the classic tablet and handler | On | Each player |

Server-wide settings can be forced by the server or the mission.
