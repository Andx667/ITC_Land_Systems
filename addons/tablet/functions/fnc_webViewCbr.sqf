#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's COBRA app: the map (a native map control over the page's map slot, drawn
 * by tablet_fnc_cbrDrawMap) and the data page with the located firing positions, to save in the
 * BCS location stores or to open a counter-fire mission on (tablet_fnc_webActionCbr).
 *
 * Arguments:
 * 0: Vehicle (the tablet's page is kept on it) <OBJECT>
 * 1: App ("cbr") <STRING>
 *
 * Return Value:
 * View <HASHMAP>
 *
 * Example:
 * [player, "cbr"] call itc_land_tablet_fnc_webViewCbr
 *
 * Public: No
 */

params ["_vehicle", "_app"];

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
        ["list", [["id", "engagement"], ["header", ["ID", "POS", "SHOTS", "LAST SHOT"]], ["rows", _rows], ["empty", LLSTRING(WebNoEngagements)]]] call FUNC(webBlock),
        ["buttons", [["items", [
            [LLSTRING(WebSaveKnownPoint), "cbrSave", ["engagement"], LLSTRING(WebSaveKnownPointTip)] call FUNC(webButton),
            [LLSTRING(cbr_data_counterFire_Text), "cbrCounterFire", ["engagement"], LLSTRING(cbr_data_counterFire_Tooltip), nil, false, "primary"] call FUNC(webButton)
        ]]]] call FUNC(webBlock)
    ]];
    _view
};

["cbr/map", {createHashMap}] call FUNC(webForm);
_view set ["title", LLSTRING(Cbr_Map)];
_view set ["blocks", [["map"] call FUNC(webBlock)]];
_view
