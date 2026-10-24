#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS locStores page interactions: "addLocation" reads the location number, grid,
 * elevation and friendly/enemy fields, converts the grid to a map position, and either adds
 * a new stored location or updates an existing one (matched by number) before re-initializing
 * the page; "removeLocation" deletes the selected location from the list.
 *
 * Arguments:
 * 0: Action identifier ("addLocation" or "removeLocation") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["addLocation"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
#include "..\bcsDefines.hpp"

switch (_action) do {
    case "addLocation": {
        private _num = UITEXT(5402);
        private _posStr = UITEXT(5404);
        private _elev = UINUMBER(5406);
        private _friendly = lbText [5408, (lbCurSel 5408)];
        if ([_num, _posStr, _elev, _friendly == "yes"] call FUNC(bcsSaveLocation)) then {
            lbAdd [5411, format["%1               %2              %3               %4", _num, _posStr, _elev, _friendly]];
        } else {
            [findDisplay 32562] call itc_land_tablet_fnc_pageInit;
        };
    };
    case "removeLocation": {
        private _index = lbCurSel 5411;
        GVAR(bcs_locations) deleteAt _index;
        lbDelete [5411, _index];
    };
};
