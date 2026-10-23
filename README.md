# ITC Land Systems [BETA]

<p align="center">
    <a href="https://github.com/Andx667/ITC_Land_Systems/issues">
        <img src="https://img.shields.io/github/issues-raw/Andx667/ITC_Land_Systems.svg?style=flat-square&label=Issues" alt="ITC Land Systems Issues">
    </a>
    <a href="https://github.com/Andx667/ITC_Land_Systems/blob/master/LICENSE">
        <img src="https://img.shields.io/badge/License-MIT-blue?style=flat-square" alt="ITC Land Systems License">
    </a>
    <br>
    <img src="https://img.shields.io/github/actions/workflow/status/Andx667/ITC_Land_Systems/check.yml?style=flat-square&label=Check" alt="Check">
    <img src="https://img.shields.io/github/actions/workflow/status/Andx667/ITC_Land_Systems/validate.yml?style=flat-square&label=Validate" alt="Validate">
</p>

__Requires__ [CBA_A3](https://github.com/CBATeam/CBA_A3) and [ACE3](https://github.com/acemod/ACE3).

__ITC Land Systems__ (ITC) adds and improves Arma 3's land-based artillery: observers and UAVs, fire control, howitzers, rocket and naval artillery, and the counter-artillery systems against incoming fire (counter-battery radar, CIWS, SAM sites). Active protection comes along as an extra.

The project is entirely __open-source__ and any contributions are welcome.

Discord: <https://discord.gg/ag4v6kxYAa>

> [!NOTE]
> ITC Land Systems is in __beta__ (0.1.0). Expect bugs and unfinished content, and please report them on the issue tracker.
>
> The project is in pre-release. The current build is being tested in game, see [issue #3](https://github.com/Andx667/ITC_Land_Systems/issues/3). A Steam Workshop release follows once that is done.

## Features

ITC Land Systems is about the artillery fight: finding targets, putting rounds on them, and detecting and stopping the enemy's incoming fire.

### Observation

- __UAVs__: AR-2i/AR-2e Darter 2 and Tayran 2, MQ-4I Greyhawk and K40i Ababil-3, UCAVi Sentinel 2, and the AL-6 as a carryable UAV bag.
- __ROVER tablet__ showing the video feed of laser-designating aircraft.
- __Strider RV__ recon vehicle (unarmed, HMG, GMG) with ITC optics readouts.
- __Packable equipment__: pack and unpack UAVs and the Remote GLTD laser designator through ACE interactions.

### Artillery and fire control

- __Self-propelled guns and rocket artillery__: M4 Sholef 2 and 2S9 Sochor 2 howitzers, Mk45 Hammer 2 naval gun (mod. 0 and mod. 1), M5 Seara 2 MLRS and Zamak MRLi.
- __Vertical Launch System__ (MN230 cruise missile variant) with a target dialog for ad-hoc and saved targets and a selectable impact angle.
- __Munitions__ for 152/155 mm, 127 mm naval and 230 mm MLRS: HE, ICM, smoke, illumination, AP/AT mines, laser-guided (LGM) and GPS-guided (PGM) rounds, and the Extra and Falat submunition rounds. Proximity, time and delay fuzes.
- __Ammunition handler__ for the self-propelled guns: pick round, charge, fuze and guidance, then watch the semi-automatic or automatic loading sequence, or prepare and drop each round by hand on a mortar. The loader status is shared with the whole crew.
- __Fire control tablet__ (handheld and vehicle-mounted): firing solutions from ballistic tables for guns and MLRS, with the time fuze setting, a battery computer (BCS) for planning and adjusting fire missions across several guns, and stored target locations.
- __Datalink__: the FDC links guns and rocket launchers into its battery and sends them firing data and fire orders, observers hand targets from UAV, GLTD and Strider optics to the FDC, and COBRA engagements become counter-fire missions.
- __Gunner sights__ with azimuth, quadrant, firing solution, fire orders and loader readouts, and an alignment guide on the crosshair. Russian guns read in 6000 mils.
- __RHS compatibility__ (loads only with RHS: AFRF / USAF): ITC versions of the 2S1, 2S3 and M109A6 with ammunition handler and mounted tablet, ITC sights and firing tables for the D-30 and M119A2, BCS firing tables for the RHS mortars.
- __BWMod compatibility__ (loads only with BWMod): ITC versions of the Panzerhaubitze 2000 with ammunition handler and mounted tablet, BCS firing tables for the MRS120 mortar.
- __GTK Boxer compatibility__ (loads only with the GTK Boxer): ITC versions of the Boxer RCH 155 with ammunition handler, mounted tablet and the ITC 155 mm rounds.
- __CUP compatibility__ (loads only with CUP Units / Vehicles): ITC versions of the D-30 and M119 with ITC sights and firing tables, of the M270 MLRS with ITC rockets, sight and mounted tablet, and of the M1129 Stryker mortar carrier as a hand-loaded 120 mm mortar.

### Counter-artillery

- __COBRA counter-battery radar__ (AN/TPQ-105, R-750): detects incoming shells, predicts their impact point and back-traces the firing position. Results show on a tablet map and data page, and alarm sirens sound near predicted impacts.
- __CIWS__ (Mk49 Spartan 2, Praetorian 2) that track and shoot down incoming artillery, mortar and rocket rounds.
- __SAM sites__: MIM-145 Defender 2 and S750 Rhea 2 with proximity-fuzed missiles.
- __Vertical Launch System__ air defence variant (MN230).

### Also included

- __Active Protection System__ that intercepts incoming rockets and missiles, with per-module arcs, ammunition and reload times.

## Documentation

The full documentation is at <https://andx667.github.io/ITC_Land_Systems/>:

- [Systems](https://andx667.github.io/ITC_Land_Systems/systems/) — every system with its vehicles, classnames and how to use it
- [Usage](https://andx667.github.io/ITC_Land_Systems/usage/) — tablets, interactions and settings
- [Compatibility](https://andx667.github.io/ITC_Land_Systems/compatibility/) — the ITC versions of RHS, CUP, BWMod and GTK Boxer artillery
- [Mission Makers & Modders](https://andx667.github.io/ITC_Land_Systems/scripting/) — what to place, and the config to add ITC features to your own vehicles

## Settings

Under __Addon Options → ITC Land Systems__ (CBA settings, can be forced by the server):

| System | Setting |
| --- | --- |
| CIWS | Enable CIWS |
| Active Protection System | Enable APS |
| COBRA | Detection range, engagement window |

## Languages

All player-facing text lives in stringtables. Only English exists so far, translations are welcome.

## Roadmap

Planned, with parts already in the code but not yet usable in game:

- 105 mm and 122 mm howitzers as a framework for other mods: weapons, ammunition, ballistic tables and fire control support ready to mount on their own vehicles. ITC Land Systems itself adds no vehicle for them.
- SADL (situational awareness) tablet app
- Dual-mode GPS/laser guided artillery rounds
- Datalink to share radar and fire-mission data between systems

Also planned: Zeus and Zeus Enhanced modules, translations, a documentation site for players and mission makers, and the Steam Workshop release. The full list is in [docs/TODO.md](./docs/TODO.md).

## Credits

ITC Land Systems is based on the original [ITC Land Systems](https://github.com/itc-addons/ITC_Land_Systems) by the ITC Addons Team and its contributors. The original project has no license and was no longer maintained, so it was considered abandoned when this continuation took it up. The new work in this beta is released under the [MIT](./LICENSE) license. This is not an official release of the original team, and the original authors are welcome to get in touch about credit or removal.

## Contributing

For new contributors, see the [Contributing Setup & Guidelines](./.github/CONTRIBUTING.md).

## License

ITC Land Systems is licensed under [MIT](./LICENSE).
