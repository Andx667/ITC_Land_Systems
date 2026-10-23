#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The values of the HTML tablet's form fields for the view shown (its key: app, page and fire
 * mission). A new view starts from its init code; the values the page sends with a button are
 * stored here (tablet_fnc_webReceive), so the page shows them after its typed drafts are gone.
 * Changing values in script (FDC ORDERS, LOAD) goes through the returned hashmap and then
 * GVAR(web) set ["formRev", ...] so the page drops its drafts.
 *
 * Arguments:
 * 0: View key <STRING>
 * 1: Code returning the initial values <CODE>
 *
 * Return Value:
 * Field values by id <HASHMAP>
 *
 * Example:
 * private _form = ["bcs/settings", {createHashMapFromArray [["splash", "5"]]}] call itc_land_tablet_fnc_webForm
 *
 * Public: No
 */

params ["_key", "_init"];

if ((GVAR(web) get "formKey") isNotEqualTo _key) then {
    GVAR(web) set ["formKey", _key];
    GVAR(web) set ["form", call _init];
    GVAR(web) set ["formRev", (GVAR(web) get "formRev") + 1];
};
GVAR(web) get "form"
