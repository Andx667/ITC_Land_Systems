# Installation

## Requirements

ITC depends on:

- [CBA_A3](https://github.com/CBATeam/CBA_A3/releases/latest)
- [ACE3](https://github.com/acemod/ACE3)

Both must be loaded **before** ITC.

## Players

1. Subscribe to the mod on the Steam Workshop once it is published, or download a release from the [Releases](https://github.com/Andx667/ITC_Land_Systems/releases) page.
2. Make sure CBA_A3 and ACE3 are also installed and enabled.
3. Enable **ITC Land Systems**, CBA_A3 and ACE3 in your mod launcher.

## Server owners

Add the mod's folder alongside CBA_A3 and ACE3 in your server's mod line, keeping the same load order (CBA_A3 → ACE3 → ITC Land Systems). Every client needs the mod as well.

The [CBA settings](usage.md#settings) for APS, CIWS and COBRA are server-wide and can be forced by the server.

## Building from source

ITC is built with [HEMTT](https://hemtt.dev/):

```cmd
winget install hemtt
```

From the repository root:

```cmd
hemtt build
```

Run `hemtt check` to validate configs, scripts and stringtables without producing a build.

`hemtt launch` starts Arma with the mod. The test range mission `.hemtt/missions/itc_land_vr_test.VR` has a station for every system and a control board for teleports, scenarios (enemy barrages, AT attacks, air targets) and diagnostics.
