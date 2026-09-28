#include "..\script_component.hpp"

/*
 * Author: Yax
 * Addon postInit entry point. Registers the APS "Fired" class event handler for all units and vehicles.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_aps_fnc_postInit
 *
 * Public: No
 */

["All", "Fired", FUNC(fired)] call CBA_fnc_addClassEventHandler;
