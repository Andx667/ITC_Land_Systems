#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The fire orders the FDC sent the vehicle (itc_land_bcs_fireData), as the values the ammunition
 * handler and the MLRS FCI fill in: round, fuze, charge and fuze setting of the sent firing line,
 * round count, and the target of a GPS guided round. The crew still checks them and applies.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: The rounds the page offers, by magazine class name <ARRAY>
 *
 * Return Value:
 * Orders, empty without fire orders <HASHMAP>
 *   "mission"   fire mission ID <STRING>
 *   "magazine"  ordered round <STRING>
 *   "round"     its index in the offered rounds, -1 if not offered <NUMBER>
 *   "fuze"      index of the ordered fuze mode, -1 if the round has none of that name <NUMBER>
 *   "charge"    charge of the firing line, within the round's charges <NUMBER>
 *   "count"     rounds per gun <NUMBER>
 *   "time"      a time fuze's setting, "" for other fuzes <STRING>
 *   "grid", "alt"  a GPS guided round's target, "" for other rounds <STRING>
 *
 * Example:
 * private _orders = [_vehicle, _rounds] call itc_land_common_fnc_getFdcOrders
 *
 * Public: No
 */

params ["_vehicle", "_magazines"];

(_vehicle getVariable [QEGVAR(bcs,fireData), []]) params [["_mission", ""], "", ["_magazine", ""], "", ["_count", 1], ["_fuzeMode", ""], ["_targetPos", []]];
if (_mission == "") exitWith {createHashMap};

private _line = [_vehicle] call FUNC(getFireSolution);
private _maxCharge = getNumber (configFile >> "CfgMagazines" >> _magazine >> "itc_land_maxChargeIndex");
private _fuzeSetting = _line param [10, -1];
private _gps = (getArray (configFile >> "CfgMagazines" >> _magazine >> "itc_land_guidance")) param [0, ""] == "gps_inertial" && {_targetPos isEqualTypeArray [0, 0, 0]};

createHashMapFromArray [
    ["mission", _mission],
    ["magazine", _magazine],
    ["round", _magazines find _magazine],
    ["fuze", getArray (([_magazine] call FUNC(getFuzeConfig)) >> "modes") find _fuzeMode],
    ["charge", ((parseNumber (_line param [0, "1"])) min _maxCharge) max 1],
    ["count", _count],
    ["time", ["", [_fuzeSetting, 1, 1] call CBA_fnc_formatNumber] select (_fuzeMode == "time" && {_fuzeSetting >= 0})],
    ["grid", if (_gps) then {([_targetPos] call ace_common_fnc_getMapGridFromPos) joinString ""} else {""}],
    ["alt", if (_gps) then {str round (_targetPos # 2)} else {""}]
]
