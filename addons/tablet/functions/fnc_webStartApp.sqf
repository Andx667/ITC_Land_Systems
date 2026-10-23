#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Switches the HTML tablet to an app, on its first page (what the classic tablet's app init
 * returns): home on its app list, the SPG and MLRS apps on the FCI page, the BCS on its settings
 * (or a handed-over target's fire mission, tablet_fnc_bcsInit), COBRA on its map. The app and
 * page are the vehicle's, as in the classic tablet, so either tablet opens where the other left.
 *
 * Arguments:
 * 0: App ("home" or one of the tablet's apps) <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["bcs"] call itc_land_tablet_fnc_webStartApp
 *
 * Public: No
 */

params ["_app"];

private _vehicle = [] call EFUNC(common,getCurVehicle);
private _shared = getText (configFile >> "itc_land" >> "apps" >> _app >> "sharedApp");
private _page = switch ([_app, _shared] select (_shared != "")) do {
    case "artillery": {"fcs"};
    case "bcs": {[] call FUNC(bcsInit)};
    case "cbr": {"map"};
    default {"appList"};
};
_vehicle setVariable [QGVAR(app), _app];
_vehicle setVariable [QGVAR(page), _page];
