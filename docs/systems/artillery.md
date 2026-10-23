# Artillery & Fire Control

Self-propelled guns, a naval gun and rocket launchers, with firing solutions computed from ballistic tables instead of the vanilla artillery computer. The ITC artillery vehicles have the vanilla artillery computer turned off: you lay the gun with the solution from the tablet and the readouts in the gunner sight.

## Vehicles

| Vehicle | Classnames | Weapon | Loader |
| --- | --- | --- | --- |
| **M4 mod. 0 Sholef 2** | `itc_land_b_SPH_Sholef2`, `itc_land_b_t_SPH_Sholef2` | 155 mm howitzer (G155) | Automatic |
| **2S9 mod. 0 Sochor 2** | `itc_land_o_sph_sochor2`, `itc_land_o_t_sph_sochor2` | 152 mm howitzer (G152) | Automatic |
| **Mk45 mod. 0 Hammer 2** | `itc_land_NGS01_hammer2` | 127 mm naval gun (NG127) | Semi-automatic |
| **Mk45 mod. 1 Hammer 2** | `itc_land_NGS01_hammer2_mod1` | 127 mm naval gun (NG127) | Automatic |
| **M5 mod. 0 Seara 2** | `itc_land_b_mlrs_seara2`, `itc_land_b_t_mlrs_seara2` | 230 mm rockets (M230) | — |
| **Zamak MRLi** | `itc_land_i_mlrs_zamak`, `itc_land_o_mlrs_zamak` | 230 mm rockets (M230) | — |

The guns hold one round at a time: every combination of round and charge is its own one-round magazine, and the [ammunition handler](#ammunition-handler) loads the right one for you.

## Munitions

### Guns (155 mm, 152 mm, 127 mm)

| Round | 155 mm | 152 mm | 127 mm | Fuze modes | Guidance |
| --- | --- | --- | --- | --- | --- |
| **HE** | ✔ | ✔ | ✔ | Point detonate, proximity, time, delay | — |
| **ICM** (cluster) | ✔ | ✔ | — | Time | — |
| **SMOKE** | ✔ | ✔ | ✔ | Time | — |
| **ILLUM** | ✔ | ✔ | ✔ | Time | — |
| **MINE-AT**, **MINE-AP** (scatterable mines) | ✔ | ✔ | — | Time | — |
| **LASER GUIDED** (LGM) | ✔ | ✔ | ✔ | Point detonate, proximity, delay | Laser code |
| **GPS GUIDED** (PGM) | ✔ | ✔ | ✔ | Point detonate, proximity, delay | Target grid and altitude |
| **EXTRA** | ✔ | — | — | Time | — |
| **FALAT** | ✔ | — | — | Time | Two laser codes |

- **Fuzes**: *point detonate* on impact, *proximity* once the shell descends below 9 m above ground, *time* once the time set in the ammunition handler has passed since firing (the cargo rounds release their payload then), *delay* shortly after impact. Only the time is set by the crew.
- **Laser guided** rounds steer to a laser spot with the matching ACE laser code.
- **GPS guided** rounds fly to the target grid and altitude set in the [ammunition handler](#ammunition-handler).
- **Extra** releases a loitering submunition when the time fuze runs out. It searches for armoured targets below it and fires a HEAT charge at the first one it finds, or destroys itself when it gets too low.
- **Falat** releases two laser-guided submunitions. Each one searches for the laser spot of its own code and fires a HEAT charge at it, or triggers after a timeout if it finds no spot.

Each round type has five propellant charges per gun.

### Rockets (230 mm)

| Rocket | Magazines | Fuze modes | Guidance |
| --- | --- | --- | --- |
| **M230 HE** | 12 rounds | Point detonate, proximity, delay | — |
| **M230 PGM** | 12 or 6 rounds | Point detonate, proximity, delay | Target grid and altitude |
| **M230 ICM** | 12 or 6 rounds | Time | — |
| **M230 G-ICM** | 12 or 6 rounds | Time | Target grid and altitude |
| **M230 MINE-AT**, **M230 MINE-AP** | 12 rounds | Time | — |

## Fire control on the tablet

The **Self Propelled Gun** app of the [mounted SPG tablet](../usage.md#tablets) computes firing solutions for the vehicle you are in.

1. Enter the **Target Position** (grid) and **Target Elevation**.
2. Pick the **Munition Type**.
3. **CALC SLN** computes a solution for every charge, low and high angle, that reaches the target.
4. Step through them with **PRV SLN** / **NXT SLN**. Each shows **SLN** (number of solutions), **CHARGE**, **AZIMUTH**, **DEFLECTION**, **QUADRANT**, **TOF** (time of flight), **MAXIMUM ORDINATE** and **TARGET DISTANCE**.

The selected solution is sent to the gunner sight as the mission azimuth and quadrant.

### Fire data from the FDC

The guns are on the datalink, so a fire direction centre can link them in the [BCS](bcs.md#1-battery-setup) and send their firing data (**SEND ADJ** / **SEND FFE**). When it arrives, the crew hears a beep and gets a hint (`FDC: fire data FM0001 FFE`), the data becomes the selected solution in the gunner sight (mission azimuth and quadrant), and the SPG app shows where it came from (**FDC FM0001 FFE** and the round) above it. The newest data wins: new data from the FDC replaces your own solution, and **CALC SLN** replaces the FDC's.

The data comes with fire orders:

- The gunner sight's **FCI ORDERS** panel appears by itself and shows the mission and ADJ/FFE, the **COUNT** of rounds, the round and charge to **LOAD**, the **FUZE** (with the time of flight for a time fuze), the target grid for a GPS round, and the azimuth and quadrant. It goes away when the FDC ends the mission or you compute your own solution.
- **FDC ORDERS** in the [ammunition handler](#ammunition-handler) fills in the round, charge, fuze, count and GPS target. Check them, set a time fuze yourself, then **APPLY** and **LOAD** as usual.
- The first shot after the data arrived is reported to the FDC, which starts its SHOT and SPLASH countdown. While the FDC's solution page is open, it sees your loader status.

**DEFLECTION** follows the US convention: 3200 mils when the target lies in the direction the gun is set to (the vehicle's direction in this app, the gun's direction in the [BCS](bcs.md) battery setup), more to the left and less to the right ("left add, right subtract"). The gun is laid by azimuth, so it is only for reference.

The **Vehicle Status** page shows the fuel level and the state of the vehicle's systems.

## Gunner sight

The gunner sight of the guns shows:

- **CA / CQ** — the current azimuth and quadrant of the gun
- **MA / MQ** — the mission azimuth and quadrant from the tablet (**FCI ORDERS**)
- the heading of the gun and the laser range
- **LOAD**, **FUZE**, **GUIDANCE** and **STATUS** of the [ammunition handler](#ammunition-handler), with the round count of the current mission (`3 / 5`)

Lay the gun until the current values match the mission values, then fire. All four values are in mils.

The guns of other mods ([compatibility](../compatibility.md)) keep their own optics and reticle; the same readouts sit in boxes at the left of their sight.

On the ITC guns, while a solution is selected, the crosshair is an alignment guide. A circle on the horizontal arm shows the azimuth error and one on the vertical arm the quadrant error; the dots are 25 mils apart, and both circles sit in the centre when the gun is laid. More than 100 mils off, an arrow at the end of the arm points the way to traverse or elevate instead.

## Ammunition handler

The gunner opens it with **Open Ammo Handling Interface** (self interaction). It loads the gun for you, one round after the other.

1. Pick the **SHELL** from the list. It shows how many of each the vehicle carries.
2. Set the **CHARGE** with the arrows (1 to the highest charge of the round).
3. Pick the **FUZE** mode and, for a time fuze, the **Time**.
4. For guided rounds, enter the **Code** (laser guided), both codes (Falat) or the **Grid** and **Elev** (GPS guided).
5. Set the **COUNT**: how many rounds to fire with these settings, 0 for no limit.
6. **APPLY SETTINGS**, then **LOAD**.

The **STATUS** follows the loading sequence until **READY TO FIRE**. An automatic loader (Sholef 2, Sochor 2, Hammer 2 mod. 1) pulls and rams the shell, inserts the charge and closes the breech, about 5 s per round. A semi-automatic one (Hammer 2 mod. 0, the ITC versions of the RHS guns) also has the crew insert the primer and attach the lanyard, about 11 to 17 s per round. After each shot the handler loads the next round until the count is reached or the selected shell runs out. **UNLOAD** removes the loaded round again.

The handler state is shared: every crew member sees the same status, and the gunner sight shows it too.

## Rocket artillery

The Seara 2 and the Zamak MRLi have the **Guided Missile Configuration** app on their mounted tablet (gunner seat). It computes firing solutions like the gun app, and sets the **fuze** (mode and time) and the **guidance** (target grid and elevation) of the rockets before you **APPLY SETTINGS**.

## Battery fire

For fire missions with several guns, see the [Battery Computer (BCS)](bcs.md).
