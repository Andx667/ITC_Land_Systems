#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Initializes the global COBRA counter-battery system state: the list of
 * active COBRA vehicles and the mission-wide starting engagement-ID counter.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_cobra_fnc_init
 *
 * Public: No
 */

itc_land_cobras = [];
GVAR(positionNames_start) = 0;
