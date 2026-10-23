# Usage

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
| **Send target to FDC** (key, ++ctrl+shift+t++) | In the ITC optics of a UAV, the GLTD or the Strider | Observer ([details](systems/uavs.md#sending-a-target-to-the-fdc)) |

## Tablets

The tablets run apps. Which apps a tablet has depends on the tablet:

| Tablet | Item | Apps |
| --- | --- | --- |
| FDC Tablet (Fire Direction Tablet) | `itc_land_tablet_fdc` | [Battery Control System](systems/bcs.md), [Counter Battery Radar](systems/cobra.md#counter-battery-radar-app) |
| SPG tablet (mounted only) | `itc_land_tablet_spg` | [Self Propelled Gun](systems/artillery.md#fire-control-on-the-tablet), [Battery Control System](systems/bcs.md) |
| MLRS tablet (mounted only) | `itc_land_tablet_mlrs` | [Guided Missile Configuration](systems/artillery.md#rocket-artillery), [Battery Control System](systems/bcs.md) |
| Rover LAD Tablet | `itc_land_tablet_rover` | [ROVER video feed](systems/uavs.md#rover-tablet) |

The vehicles carry a **mounted tablet**: the SPG tablet in the Sholef 2, Sochor 2 and Hammer 2, the MLRS tablet in the Seara 2 and Zamak MRLi. The mounted tablet works on the vehicle you sit in. Only the FDC and ROVER tablets are carried as items.

## Settings

Under **Addon Options → ITC Land Systems** (CBA settings):

| Category | Setting | Default | Scope |
| --- | --- | --- | --- |
| Active Protection System | **Enable APS** — vehicles with an [active protection system](systems/aps.md) intercept incoming rockets and missiles | On | Server-wide |
| CIWS | **Enable CIWS** — [CIWS](systems/air-defence.md#ciws) turrets track and shoot down incoming artillery, mortar and rocket rounds | On | Server-wide |
| COBRA Counter-Battery Radar | **Detection range** — maximum distance at which a [COBRA](systems/cobra.md) detects incoming rounds | 10 000 m (1 000–20 000) | Server-wide |
| Fire control | **Russian guns in 6000 mils** — the Russian guns (Sochor 2, 2S1, 2S3, D-30, 2B14) and their BCS batteries show angles in the Russian 6000 mil system, written `15-00`, and the BCS reads those batteries' mil inputs (OT and sheaf direction) in it; off: NATO 6400 mils everywhere | On | Server-wide |
| COBRA Counter-Battery Radar | **Engagement window** — seconds after the last detected shot during which new shots from within 300 m are added to the same engagement | 30 s (5–300) | Server-wide |
| Tablet | **Tablet in HTML** — the tablets open as a web page (Arma 3 2.20 browser control) with the same apps; **CLASSIC TABLET** on its home screen opens the classic one | Off | Each player |

Server-wide settings can be forced by the server or the mission.

## Languages

All player-facing text lives in stringtables. Only English exists so far, translations are welcome — see [Contributing](contributing.md).
