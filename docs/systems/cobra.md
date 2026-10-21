# Counter-Battery Radar

COBRA radars detect incoming artillery shells, predict where they land and back-trace where they were fired from. Detected firing positions are grouped into engagements, and sirens near a predicted impact sound the alarm.

## Vehicles

| Radar | Classname |
| --- | --- |
| **AN/TPQ-105 COBRA** | `itc_land_COBRA01` |
| **R-750 Mod 2. COBRA** | `itc_land_COBRA02` |
| **COBRA Siren** | `ITC_Land_Loudspeakers` |
| **COBRA Siren 2** | `ITC_Land_Loudspeakers2` |

## How it works

- A COBRA covers a 46° arc (23° to each side of where its radar faces) up to the [detection range](../usage.md#settings) (10 km by default). It only detects while it stands still and has line of sight to the shell.
- It tracks artillery shells: every shell based on the vanilla 155 mm artillery shell (the ITC gun shells and the vanilla howitzer shells) and guided 82 mm mortar rounds. Rockets and unguided mortar rounds are not detected.
- The first COBRA that sees a shell predicts its impact point and time, and back-traces the firing position.
- Shots from within 300 m of a known firing position that come within the [engagement window](../usage.md#settings) (30 s by default) of the last one count to the same engagement.
- The simulation runs on the server and is shared with every player.

## Sirens

Place a **COBRA Siren** near what you want to warn. When a COBRA predicts an impact within 500 m of a siren, the siren sounds until that shell has landed:

| Siren | Sound | Heard up to |
| --- | --- | --- |
| **COBRA Siren** | Car alarm | 200 m |
| **COBRA Siren 2** | VTOL alarm | 400 m |

Any other object can be made a siren too, see [Mission Makers & Modders](../scripting.md#cobra-sirens).

## Counter Battery Radar app

The **Counter Battery Radar** app on the [FDC tablet](../usage.md#tablets) shows what the COBRAs see:

- **Map view** — every COBRA with the edges of its arc, the detected firing positions in red with the number of rounds fired from them, and the predicted impacts with the seconds until they land
- **Data view** — the list of engagements with their position, number of shots and the time of the last shot. **Save to BCS** stores the selected firing position in the [BCS location stores](bcs.md#location-stores), ready for a counter-battery fire mission
