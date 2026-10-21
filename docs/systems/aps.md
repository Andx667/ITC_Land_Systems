# Active Protection

An active protection system (APS) intercepts incoming rockets and missiles before they hit the vehicle. ITC fits APS to the vanilla main battle tanks.

| Tank | Classname | System | Arc per module | Range | Shots per module | Kill chance |
| --- | --- | --- | --- | --- | --- | --- |
| **M2A1 Slammer** | `B_MBT_01_cannon_F` | **Trophy** left and right | 186°, centred on its side (together all round) | 15 m | 10 | 80 % |
| **T-100 Varsuk** | `O_MBT_02_cannon_F` | **Drozd** left and right | 90°, centred 40° left or right of the front | 15 m | 4 | 30 % |
| **T-140 Angara** (all variants) | `MBT_04_base_F` and every class derived from it | **Afghanit** left and right | 110°, centred 50° left or right of the front | 30 m | 5 | 80 % |

## How it works

- Every rocket and missile in flight is watched. When it is heading for a vehicle with an APS, each module checks whether the round is within its range and arc, it has line of sight to it, it has shots left and it is not reloading.
- The first module that can engage fires. On a kill the round is detonated short of the vehicle; on a miss it flies on, and the next module (or the next check) can try again.
- The modules are mounted on the turret, so their arcs turn with it.
- Shells, bullets and grenades are not intercepted, only rockets and missiles.
- Spent shots are **not** refilled by rearming. A module's shots are back only when the vehicle respawns or is created again.
- The APS can be switched off with the **Enable APS** [setting](../usage.md#settings).

Fitting an APS to other vehicles is described in [Mission Makers & Modders](../scripting.md#active-protection).
