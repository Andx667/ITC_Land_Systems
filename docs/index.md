# ITC Land Systems

![ITC Land Systems Logo](assets/logo.png){ width="320" }

**ITC Land Systems** (ITC) adds and improves Arma 3's land-based weapon systems: self-propelled artillery with real fire control, a battery computer for fire missions across several guns, counter-battery radar, air and missile defence, active protection for tanks, guided munitions and UAVs.

The project is entirely open-source and any contributions are welcome — see [Contributing](contributing.md).

!!! warning "Beta"
    ITC Land Systems is in beta (0.1.0). Features are still being tested and balanced, and you may run into bugs or unfinished content. Please report problems on the [issue tracker](https://github.com/Andx667/ITC_Land_Systems/issues).

!!! info "Requirements"
    ITC requires [CBA_A3](https://github.com/CBATeam/CBA_A3/releases/latest) and [ACE3](https://github.com/acemod/ACE3), see [Installation](installation.md).

## Core Features

- **[Artillery & fire control](systems/artillery.md)** — M4 Sholef 2 and 2S9 Sochor 2 howitzers, the Mk45 Hammer 2 naval gun, and the M5 Seara 2 and Zamak MRLi rocket launchers. Firing solutions from ballistic tables on a vehicle tablet, gunner sights with mission azimuth and quadrant, and an ammunition handler that loads shell, charge and fuze for you.
- **[Munitions](systems/artillery.md#munitions)** — HE, ICM, smoke, illumination, AP and AT mines, laser-guided and GPS-guided rounds, and the Extra and Falat submunition rounds, with proximity, point detonate, time and delay fuzes.
- **[Battery computer (BCS)](systems/bcs.md)** — plan, adjust and fire missions with a whole battery from the fire direction tablet, with sheaf patterns and stored target locations.
- **[Counter-battery radar](systems/cobra.md)** — COBRA radars detect incoming shells, predict their impact and back-trace the firing position. Sirens sound near predicted impacts.
- **[Air & missile defence](systems/air-defence.md)** — CIWS that shoot down incoming shells, rockets and missiles, SAM sites with proximity-fuzed missiles, and a vertical launch system with a target dialog.
- **[Active protection](systems/aps.md)** — Trophy, Drozd and Afghanit systems on the vanilla main battle tanks intercept incoming rockets and missiles.
- **[Spike LR](systems/spike.md)** — a man-portable anti-tank missile with a camera seeker you steer and lock in flight.
- **[UAVs & recon](systems/uavs.md)** — new UAVs, packable UAVs and laser designators, the ROVER tablet with the video feed of laser-designating aircraft, and the Strider RV.
- Every system that can be switched off has a [CBA setting](usage.md#settings).

## Getting Started

- [Installation](installation.md) — how to get the mod running alongside CBA and ACE3
- [Usage](usage.md) — tablets, interactions and settings
- [Systems](systems/index.md) — every system with its vehicles, classnames and how to use it
- [Mission Makers & Modders](scripting.md) — what to place, and the config to add ITC features to your own vehicles
- [Components](components.md) — a tour of the addons that make up the mod

## Credits

ITC Land Systems is based on the original [ITC Land Systems](https://github.com/itc-addons/ITC_Land_Systems) by the ITC Addons Team and its contributors. The original project has no license and was no longer maintained, so it was considered abandoned when this continuation took it up. This is not an official release of the original team, and the original authors are welcome to get in touch about credit or removal. See [License](license.md).
