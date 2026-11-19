#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's BCS start page (tablet\CfgMisc.hpp webStartFunction): starts the BCS
 * (tablet_fnc_bcsInit) and opens where the FDC works rather than on the settings: a handed-over
 * target's fire mission, the battery setup while the battery has no guns, then the fire mission
 * last open (or the newest one), else the location stores.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Page to open <STRING>
 *
 * Example:
 * [] call itc_land_tablet_fnc_webStartBcs
 *
 * Public: No
 */

private _page = [] call FUNC(bcsInit);
if (_page != "settings") exitWith {_page};
if (GVAR(bcs_bty_guns) isEqualTo []) exitWith {"setup"};
if (GVAR(bcs_missions) isEqualTo []) exitWith {"locStores"};
if (GVAR(bcs_mission_index) < 0 || {GVAR(bcs_mission_index) >= count GVAR(bcs_missions)}) then {
    GVAR(bcs_mission_index) = count GVAR(bcs_missions) - 1;
};
(GVAR(bcs_missions) # GVAR(bcs_mission_index)) # 1
