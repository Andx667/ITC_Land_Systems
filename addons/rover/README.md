# Rover

`itc_land_rover`: [ROVER tablet](../../docs/systems/uavs.md#rover-tablet).

## Dependencies

- ITC: `itc_land_common`
- ACE: `ace_huntir`, `ace_interaction`

## Files

- `CfgVehicles.hpp`
- `CfgWeapons.hpp`
- `config/baseControls.hpp`
- `config/tablet.hpp`

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_createFeed` |  | Sets up the rover UI's video feed for the given aircraft: hides the default optics controls, switches the rover camera to an internal back-facing view, and applies the color-correction/film-grain post-process effects used for the feed's DTV look. |
| `fnc_getAircraft` |  | Finds all air vehicles friendly to ace_player that carry a laser-designator turret, for use in the rover UI's aircraft selection list. |
| `fnc_getLaserTurret` |  | Finds the first turret (including the driver position) on the given vehicle that carries a laser-designator weapon. |
| `fnc_init` |  | Initializes the rover UI's global state: the selectable aircraft list, the camera field-of-view value, and the stored optics memory point position. |
| `fnc_killFeed` |  | Tears down the rover UI's video feed: restores the default optics controls, disables NVG/thermal vision, terminates the rover camera effect, and disables the feed's color-correction/film-grain post-process effects. |
| `fnc_ui_draw` |  | Updates the rover UI's HUD controls for the given aircraft: viewer direction (degrees/mils), target and aircraft grid references, target/aircraft ASL and AGL altitudes, aircraft speed, the north-arrow compass, and the clock display. |
| `fnc_ui_init` |  | Initializes the rover UI dialog: creates the rover camera, populates the aircraft list box, creates the video feed for the current aircraft, restores the FOV slider and vision mode, and starts a per-frame handler that keeps the feed, camera position/target and HUD updated while the dialog is open and the player is alive, tearing everything down once it closes or the player dies. |
| `fnc_ui_populateListBox` |  | Rebuilds the rover UI's aircraft list box from the currently available friendly aircraft, restoring the previous selection if that aircraft is still present, and updates the current selection index/aircraft globals. |
| `fnc_ui_update` |  | Handles a selection change in the rover UI's aircraft list box: stores the newly selected index/aircraft, recreates the video feed for it, and recomputes the camera's optics memory point position from its laser turret (or driver optics if it has none). |
| `fnc_ui_vismode` |  | Switches the rover camera's vision mode (day/NVG/white-hot/black-hot) or updates the stored FOV slider value, based on the given UI button id, and remembers the selected vision mode for future dialog opens. |
