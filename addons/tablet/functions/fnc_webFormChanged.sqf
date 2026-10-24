#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Tells the HTML tablet that script changed its form values (tablet_fnc_webForm): the page drops
 * what was typed and shows them.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_tablet_fnc_webFormChanged
 *
 * Public: No
 */

GVAR(web) set ["formRev", (GVAR(web) get "formRev") + 1];
