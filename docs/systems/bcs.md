# Battery Computer (BCS)

The **Battery Control System** app plans fire missions for a whole battery. It runs on the FDC tablet of the fire direction centre and on the mounted SPG and MLRS tablets (see [Tablets](../usage.md#tablets)).

The BCS is a fire direction computer: it gives you the firing data for every gun of the battery, which the fire direction centre passes on to the gun crews. Each gun lays with its own [gunner sight](artillery.md#gunner-sight) and [ammunition handler](artillery.md#ammunition-handler).

## Battery types

| Battery type | Guns |
| --- | --- |
| **G155 155mm Howitzer** | M4 Sholef 2 |
| **G152 152mm Howitzer** | 2S9 Sochor 2 |
| **NG127 127mm Naval Gun** | Mk45 Hammer 2 |
| **M230 227mm MLRS** | M5 Seara 2, Zamak MRLi |
| **Mk6 82mm Mortar** | Vanilla Mk6 mortar |

## Workflow

### 1. Battery setup

Open **Bty Setup**:

1. Enter the **Battery Callsign** and pick the **Gun Type** (battery type), then **SAVE BTY TYPE**.
2. For every gun, enter the **Gun #**, its grid, elevation and direction, and **SAVE GUN**. Saving a number that already exists updates that gun; **REMOVE** deletes the selected one.

The battery position used for the battery-centre solution is the average of the gun positions.

### 2. New fire mission

Open **New Firemission** and choose the **Target Type**:

| Target type | Target from |
| --- | --- |
| **Grid** | A grid reference and elevation |
| **Shift** | A shift from a known point: **OT** direction (observer–target, in mils), **AD** add/drop (metres along the OT line, positive adds range), **LR** left/right (metres perpendicular to the OT line), **UD** up/down (metres) |
| **Polar** | A polar shift from a known point |
| **QuickLay** | An offset from the battery's own position |

**Known Point** → **Load** fills the fields from a [stored location](#location-stores). **Next** saves the target and continues.

### 3. Engagement

Set how the battery engages:

- **Ammo Type** (shell), **COUNT** and **FUZE**
- **Sheaf Type**: parallel, converged, linear, open or special — where each gun aims relative to the target
- **Quick Sheaf**, **Direction** and **Length** for the sheaf
- Adjust (**ADJ**) or fire for effect (**FFE**)

**Next** computes the solutions.

### 4. Solution

The solution page shows the selected solution's **MAXIMUM ORDINATE**, **IMPACT ANGLE** and **TARGET DISTANCE**, and per gun the charge, azimuth, deflection, quadrant and time of flight. **SLN+** / **SLN-** step through the solutions (charges, low and high angle). **NO SOLUTIONS** with the range means the target is out of reach for this battery type.

- **SHOT** records when the rounds were fired; with **Alert To Splash** set in the [BCS settings](#settings), you are warned before they land (**SPLASH**).
- **ADJUST/FFE** opens the adjustment page: enter the observer's correction (OT, add/drop, left/right, up/down) to move the target and recalculate.
- **END MISSION** ends the mission; **END & SAVE** first stores its target as a known point.

### Location stores

**Location Stores** keeps known points with a **Reference ID**, **Position**, **Elevation** and whether it is **Friendly**. **ADD NEW** adds a point or updates the one with the same ID, **REMOVE** deletes the selected one. The [counter-battery radar app](cobra.md#counter-battery-radar-app) can save detected firing positions here.

## Settings

**BCS Settings**: the **Firemission Code** and **Firemission Start** number name new missions, **Alert To Splash** sets how long before impact the splash warning comes. **Save** stores them.
