#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's COBRA app: the map (a native map control over the page's map slot, drawn
 * by tablet_fnc_cbrDrawMap) and the data page with the located firing positions, to save in the
 * BCS location stores or to open a counter-fire mission on (tablet_fnc_webActionCbr).
 *
 * Arguments:
 * 0: Vehicle (the tablet's page is kept on it) <OBJECT>
 *
 * Return Value:
 * View <HASHMAP>
 *
 * Example:
 * [player] call itc_land_tablet_fnc_webViewCbr
 *
 * Public: No
 */

params ["_vehicle"];

private _page = _vehicle getVariable [QGVAR(page), "map"];
private _view = createHashMapFromArray [
    ["header1", "COBRA"],
    ["header2", LLSTRING(Cbr_RadarSuite)],
    ["side", [
        [LLSTRING(Cbr_MapView), "page", [], "", "map", _page == "map"] call FUNC(webButton),
        [LLSTRING(Cbr_DataView), "page", [], "", "data", _page == "data"] call FUNC(webButton)
    ]]
];

if (_page == "data") exitWith {
    ["cbr/data", {createHashMapFromArray [["engagement", 0]]}] call FUNC(webForm);
    private _rows = (missionNamespace getVariable ["itc_land_cobra_engagements", []]) apply {
        [_x # 0, [_x # 2 # 0] call EFUNC(common,posToGrid), _x # 1, (_x # 5) call BIS_fnc_timeToString]
    };
    _view set ["title", LLSTRING(Cbr_Data)];
    _view set ["blocks", [
        createHashMapFromArray [["t", "list"], ["id", "engagement"], ["header", ["ID", "POS", "SHOTS", "LAST SHOT"]], ["rows", _rows]],
        createHashMapFromArray [["t", "buttons"], ["items", [
            [LLSTRING(cbr_data_saveOriginPos_Text), "cbrSave", ["engagement"]] call FUNC(webButton),
            [LLSTRING(cbr_data_counterFire_Text), "cbrCounterFire", ["engagement"], LLSTRING(cbr_data_counterFire_Tooltip)] call FUNC(webButton)
        ]]]
    ]];
    _view
};

["cbr/map", {createHashMap}] call FUNC(webForm);
_view set ["title", LLSTRING(Cbr_Map)];
_view set ["blocks", [createHashMapFromArray [["t", "map"]]]];
_view
