#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the rover UI's global state: the selectable aircraft list, the
 * camera field-of-view value, and the stored optics memory point position.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_rover_fnc_init
 *
 * Public: No
 */

itc_land_rover_ui_aircraftList = [];
itc_land_rover_ui_camFov = 5/120;
itc_land_rover_mempointPos = [0,0,0];
