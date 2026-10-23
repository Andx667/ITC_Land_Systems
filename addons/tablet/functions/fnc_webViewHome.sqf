#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's home screen: the tablet's apps on APP 1-3, with the vehicle systems each
 * needs, and the logo, as on the classic tablet's app list.
 *
 * Arguments:
 * 0: Vehicle (the tablet's state is kept on it) <OBJECT>
 * 1: The tablet's apps <ARRAY>
 *
 * Return Value:
 * View <HASHMAP>
 *
 * Example:
 * [_vehicle, ["bcs", "cbr"]] call itc_land_tablet_fnc_webViewHome
 *
 * Public: No
 */

params ["_vehicle", "_apps"];

["home", {createHashMap}] call FUNC(webForm);

private _tiles = [];
{
    private _config = configFile >> "itc_land" >> "apps" >> _x;
    _tiles pushBack createHashMapFromArray [
        ["label", toUpper format [LLSTRING(Home_AppEntry), _forEachIndex + 1, getText (_config >> "displayName")]],
        ["note", toUpper getText (_config >> "interfaces")],
        ["tip", LLSTRING(Home_Interfaces_Tooltip)],
        ["a", "key"],
        ["v", _forEachIndex]
    ];
} forEach (_apps select [0, 3]);

createHashMapFromArray [
    ["header1", LLSTRING(header1_Text)],
    ["header2", LLSTRING(header2_Text)],
    ["title", getText (configFile >> "CfgWeapons" >> (GVAR(web) get "tablet") >> "displayName")],
    ["side", []],
    ["blocks", [
        createHashMapFromArray [["t", "tiles"], ["items", _tiles]],
        createHashMapFromArray [["t", "buttons"], ["items", [[LLSTRING(WebClassic), "classic", [], LLSTRING(WebClassic_Tooltip)] call FUNC(webButton)]]],
        createHashMapFromArray [["t", "image"], ["path", QPATHTOF(UI\logo.paa) select [1]]]
    ]]
]
