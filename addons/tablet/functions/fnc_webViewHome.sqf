#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's home screen: the tablet's apps on APP 1-3, with the vehicle systems each
 * needs, and the logo, as on the classic tablet's app list.
 *
 * Arguments:
 * 0: Vehicle (the tablet's state is kept on it) <OBJECT>
 * 1: App ("home") <STRING>
 *
 * Return Value:
 * View <HASHMAP>
 *
 * Example:
 * [_vehicle, "home"] call itc_land_tablet_fnc_webViewHome
 *
 * Public: No
 */

params ["_vehicle", "_app"];

["home", {createHashMap}] call FUNC(webForm);

private _tablet = configFile >> "CfgWeapons" >> (GVAR(web) get "tablet");
private _tiles = [];
{
    private _config = configFile >> "itc_land" >> "apps" >> _x;
    _tiles pushBack createHashMapFromArray [
        ["label", toUpper format [LLSTRING(Home_AppEntry), _forEachIndex + 1, getText (_config >> "displayName")]],
        // the vehicle systems the app needs; none ("-") is left out
        ["note", [toUpper getText (_config >> "interfaces"), ""] select (getText (_config >> "interfaces") in ["", "-"])],
        ["tip", LLSTRING(Home_Interfaces_Tooltip)],
        ["a", "key"],
        ["v", _forEachIndex]
    ];
} forEach (getArray (_tablet >> "apps") select [0, 3]);

createHashMapFromArray [
    ["header1", LLSTRING(header1_Text)],
    ["header2", LLSTRING(header2_Text)],
    ["title", getText (_tablet >> "displayName")],
    ["side", []],
    ["blocks", [
        ["tiles", [["items", _tiles]]] call FUNC(webBlock),
        ["bar", [["groups", [[[LLSTRING(WebClassic), "classic", [], LLSTRING(WebClassic_Tooltip)] call FUNC(webButton)]]]]] call FUNC(webBlock),
        ["image", [["path", QPATHTOF(UI\logo.paa) select [1]]]] call FUNC(webBlock)
    ]]
]
