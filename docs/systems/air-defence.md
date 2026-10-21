# Air & Missile Defence

## CIWS

Close-in weapon systems that track and shoot down incoming artillery shells, rockets, missiles and bombs. They are crewed by UAV AI and engage on their own.

| CIWS | Classnames | Armament |
| --- | --- | --- |
| **Praetorian 2 Mod 0** | `itc_land_cram_praetorian2` (NATO), `itc_land_cram_praetorian2_o` (CSAT) | 20 mm Phalanx gun, radar (20 km) and IR sensors |
| **Mk49 Spartan 2 Mod 0** | `itc_land_ciws_centurion2` (NATO) | Short-range missiles, IR sensor |

- The CIWS engage rounds whose ammunition is in the [interceptable list](../scripting.md#ciws-interceptable-ammunition): artillery shells, guided mortar rounds, the ITC 230 mm rockets, guided and unguided bombs, air-to-ground, anti-radiation and cruise missiles.
- About a second after such a round is fired, the CIWS can see it. A round that is shot down disappears in the air.
- The Praetorian's radar is switched on as soon as it is placed, by the editor, Zeus or a script.
- They are anti-air only: their sensors do not see ground vehicles and do not report them over datalink.
- The CIWS can be switched off with the **Enable CIWS** [setting](../usage.md#settings).

## SAM sites

Surface-to-air missile launchers whose missiles have a proximity fuze: they detonate as soon as an aircraft enters the warhead's sensor cone, instead of having to hit it.

| SAM site | Classname | Side |
| --- | --- | --- |
| **MIM-145 mod. 0 Defender 2** | `itc_land_b_defender2` | NATO |
| **S750 mod. 0 Rhea 2** | `itc_land_o_rhea2` | CSAT |

## Vertical launch system

| VLS | Classname | Missiles |
| --- | --- | --- |
| **MN230 VLS (Air Defense)** | `itc_land_b_vls2` | 18 surface-to-air missiles |
| **MN230 VLS (Cruise Missile)** | `itc_land_b_vls2_slam` | 18 cruise missiles |

!!! info "User input only"
    The ITC launchers only fire on user input: from the gunner seat, from the VLS interface or by script. An AI gunner never launches on its own, also not at targets it receives over datalink. The vanilla VLS is not affected.

### VLS interface

In the cruise missile VLS, open **Open VLS Interface** (self interaction).

- Enter a target with **NAME**, **GRID**, **ELEV** (elevation) and **ANGL** (impact angle), then **SAVE TO LIST**. The **TARGET LIST** shows every saved target.
- **LAUNCH SELECTED** fires a missile at the target selected in the list. **REMOVE FROM LIST** deletes it.
- **ADHOC LAUNCH** fires at the grid, elevation and angle entered in the fields without saving them.

The missile flies to the target and dives onto it at the selected impact angle. A missile fired without a target (by a script, for example) flies unguided.
