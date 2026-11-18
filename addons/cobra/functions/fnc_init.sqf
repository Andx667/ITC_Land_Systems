#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Initializes the server-side COBRA counter-battery state: the list of COBRA
 * vehicles, the tracked shells, the recorded origins, firing positions,
 * engagements and predicted impacts, and the engagement ID counter. The
 * detection range and engagement time window are CBA settings. Only the
 * server runs the COBRA simulation. Clients start with empty copies of its
 * results (itc_land_cobras, itc_land_cobra_firingPositions,
 * itc_land_cobra_engagements, itc_land_cobra_activeShells), which the
 * events in XEH_postInit keep up to date.
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
itc_land_cobra_firingPositions = [];
itc_land_cobra_engagements = [];
itc_land_cobra_activeShells = [];

if (!isServer) exitWith {};

itc_land_cobra_shells = [];
itc_land_cobra_origins = [];
itc_land_cobra_start = 1000;
