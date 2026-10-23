# Battery Computer (BCS)

The **Battery Control System** app plans fire missions for a whole battery. It runs on the FDC tablet of the fire direction centre and on the mounted SPG and MLRS tablets (see [Tablets](../usage.md#tablets)).

The BCS is a fire direction computer: it gives you the firing data for every gun of the battery. Guns linked over the datalink get their data straight into their [gunner sight](artillery.md#gunner-sight) (**SEND ADJ** / **SEND FFE**); for other guns the fire direction centre passes it on by voice. Each gun lays with its own gunner sight and [ammunition handler](artillery.md#ammunition-handler).

## Battery types

| Battery type | Guns |
| --- | --- |
| **G155 155mm Howitzer** | M4 Sholef 2 |
| **G152 152mm Howitzer** | 2S9 Sochor 2 |
| **NG127 127mm Naval Gun** | Mk45 Hammer 2 |
| **M230 230mm MLRS** | M5 Seara 2, Zamak MRLi |
| **Mk6 82mm Mortar** | Vanilla Mk6 mortar |

## Workflow

### 1. Battery setup

Open **Bty Setup**:

1. Enter the **Battery Callsign** and pick the **Gun Type** (battery type), then **SAVE BTY TYPE**.
2. Add the guns:
    - **Link gun** lists the ITC guns of the battery type on your side that are on the datalink, nearest first, with their datalink ID and grid. **LINK** adds the selected one as the next gun number. A linked gun shows its ID in the gun list (**LOST** once it is destroyed or gone); its position, elevation and direction come from the vehicle before each calculation, its solutions start at its muzzle, and it only gets the solutions its turret can lay.
    - Guns without ITC fire control (other mods' guns, mortars): enter the **Gun #**, its grid, elevation and direction, and **SAVE GUN**. Saving a number that already exists updates that gun (a linked one becomes a hand-entered one); **REMOVE** deletes the selected one. Hand-entered guns only get the solutions the battery type's guns can lay.

The battery position used for the battery-centre solution is the average of the gun positions.

Every ITC gun and rocket launcher with a mounted tablet (Sholef 2, Sochor 2, Hammer 2, Seara 2, Zamak MRLi and the ITC self-propelled guns of other mods, the CUP M1129 and M270, see [Compatibility](../compatibility.md)) joins the datalink by itself. The towed guns (D-30, M119) are just the gun, with no tablet: their crews work by voice, so enter them by hand and pass their data by radio. Guided rockets get their fixed 800 mils quadrant in the BCS as in the launcher's app.

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

- **Ammo Type** (shell), its **Fuze** and the **Count** of rounds per gun: the linked guns get them as their fire orders
- **Sheaf Type**: parallel, converged, linear, open or special — where each gun aims relative to the target
- **Quick Sheaf**, **Direction** and **Length** for the sheaf

**Next** computes the solutions.

### 4. Solution

The solution page shows the selected solution's **MAXIMUM ORDINATE**, **IMPACT ANGLE** and **TARGET DISTANCE**, and per gun the charge, azimuth, deflection, quadrant, time of flight and, for rounds with a time fuze, the fuze setting (**FS**, see [Fire control on the tablet](artillery.md#fire-control-on-the-tablet)) for the same charge and angle. **SLN+** / **SLN-** step through the solutions (charges, low and high angle). **NO SOLUTIONS** with the range means the target is out of reach for this battery type; **NO SLN** on a gun means that gun has no solution for the selected charge and angle (out of range, or a quadrant it cannot lay).

- **SEND ADJ** sends the firing data of the gun selected in the list (the first gun if none is), for adjusting fire; **SEND FFE** sends every gun its data, for fire for effect. Each linked gun gets its line as the selected solution in its gunner sight and SPG app, and the round, fuze and count as fire orders (the **FCI ORDERS** panel in its sight, **FDC ORDERS** in its ammunition handler); its crew gets a beep and a hint. A hint tells you which guns got the data, which are not linked and which have no solution. After an adjustment, send again. While the solution page is open, each linked gun's row shows its loader status (for example `READY TO FIRE ( 1 / 3 )`).

- **SHOT**: a linked gun reports its first shot of the data you sent, which starts SHOT by itself (hint `FM0001: SHOT reported by the guns`); for guns that are not linked, press it when they report the rounds fired. The page counts down the time to impact (**TTI**) and the mission list shows the mission as **SHOT**. **Alert To Splash** seconds before impact (5 by default, [BCS settings](#settings)) it turns to **SPLASH**, with a beep and a hint, also while the tablet is closed: the moment to call "splash" to the observer. If the time of flight is shorter, the alert comes right away. Ending the mission or pressing SHOT again cancels the pending alert.
- **ADJUST/FFE** opens the adjustment page: enter the observer's correction (OT, add/drop, left/right, up/down) to move the target and recalculate.
- **END MISSION** ends the mission and clears its fire orders on the linked guns; **END & SAVE** first stores its target as a known point.

### Location stores

**Location Stores** keeps known points with a **Reference ID**, **Position**, **Elevation** and whether it is **Friendly**. **ADD NEW** adds a point or updates the one with the same ID, **REMOVE** deletes the selected one. The [counter-battery radar app](cobra.md#counter-battery-radar-app) can save detected firing positions here, and targets observers send from the ITC optics arrive here as **TGT01**, **TGT02**, … ([Sending a target to the FDC](uavs.md#sending-a-target-to-the-fdc)).

## Russian batteries

The Russian battery types (G152 for the Sochor 2, and with RHS or CUP the 2S1, 2S3, D-30 and 2B14) work in the Russian 6000 mil system while the **Russian guns in 6000 mils** [setting](../usage.md#settings) is on: the gun lines show azimuth, deflection and quadrant as `15-00`, and the OT direction (Shift, Polar, adjustment) and the sheaf direction are entered in it, as `1500` or `15-00`. Other batteries use NATO 6400 mils.

## Settings

**BCS Settings**: the **Firemission Code** and **Firemission Start** number name new missions, **Alert To Splash** sets how many seconds before impact the splash warning comes (more than 0, default 5). **Save** stores them; with an invalid Alert To Splash nothing is saved and a hint says why.
