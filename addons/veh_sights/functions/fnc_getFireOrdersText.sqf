#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Builds the six lines of the gunner sight's FCI ORDERS panel from the fire orders the FDC sent
 * the vehicle (itc_land_bcs_fireData) and the firing line they came with: mission and ADJ/FFE,
 * round count, round and charge, fuze (with the fuze setting for a time fuze), guidance (the
 * target grid for a GPS round) and azimuth/quadrant. Without orders the lines are placeholders.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * Title, count, load, fuze, guidance and AZ/QD lines <ARRAY of STRING>
 *
 * Example:
 * [vehicle player] call itc_land_veh_sights_fnc_getFireOrdersText
 *
 * Public: No
 */

params ["_vehicle"];

(_vehicle getVariable ["itc_land_bcs_fireData", []]) params [["_mission", ""], ["_phase", ""], ["_magazine", ""], "", ["_count", 1], ["_fuzeMode", ""], ["_targetPos", []]];
if (_mission == "") exitWith {
    [
        LLSTRING(FciOrders),
        LLSTRING(CountNotAvailable),
        LLSTRING(LoadNotAvailable),
        LLSTRING(FuzeNotAvailable),
        LLSTRING(GuidanceNotAvailable),
        "AZ/QD: -- N/A --"
    ]
};

private _line = [_vehicle] call EFUNC(common,getFireSolution);
private _magazineConfig = configFile >> "CfgMagazines" >> _magazine;

private _fuze = configFile >> "ITC_Land_CfgFuzes" >> getText (_magazineConfig >> "itc_land_fuze");
private _fuzeIndex = getArray (_fuze >> "modes") find _fuzeMode;
private _fuzeName = if (_fuzeIndex == -1) then {""} else {getArray (_fuze >> "modeDesc") param [_fuzeIndex, ""]};
private _fuzeText = switch (true) do {
    case (_fuzeName == ""): {LLSTRING(FuzeNotAvailable)};
    case (_fuzeMode == "time"): {format [LLSTRING(OrdersFuzeTime), toUpper _fuzeName, [(_line param [10, -1]) max 0, 1, 1] call CBA_fnc_formatNumber]};
    default {format [LLSTRING(OrdersFuzeMode), toUpper _fuzeName]};
};

private _guidanceText = if ((getArray (_magazineConfig >> "itc_land_guidance")) param [0, ""] == "gps_inertial" && {_targetPos isEqualTypeArray [0, 0, 0]}) then {
    format [LLSTRING(OrdersGuidanceGps), [_targetPos] call EFUNC(common,posToGrid), round (_targetPos # 2)]
} else {
    LLSTRING(GuidanceNotAvailable)
};

[
    format [LLSTRING(OrdersTitle), _mission, _phase],
    format [LLSTRING(OrdersCount), _count],
    format [LLSTRING(OrdersLoad), getText (_magazineConfig >> "displayNameShort"), _line param [0, "-"]],
    _fuzeText,
    _guidanceText,
    format ["AZ/QD: %1 / %2", [_vehicle, 1] call EFUNC(common,getSolutionText), [_vehicle, 3] call EFUNC(common,getSolutionText)]
]
