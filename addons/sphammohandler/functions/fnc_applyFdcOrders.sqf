#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * FDC ORDERS button of the ammunition handler: fills in the fire orders the FDC sent the vehicle
 * (itc_land_bcs_fireData): the round, the charge of the sent firing line, the fuze (a time fuze
 * with the line's fuze setting), the round count and, for a GPS round, the target grid and
 * altitude. It only pre-fills the dialog: the crew still checks it, then APPLY and LOAD, and lays
 * the gun.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_land_sphammohandler_fnc_applyFdcOrders
 *
 * Public: No
 */

private _vehicle = [] call EFUNC(common,getCurVehicle);
(_vehicle getVariable ["itc_land_bcs_fireData", []]) params [["_mission", ""], "", ["_magazine", ""], "", ["_count", 1], ["_fuzeMode", ""], ["_targetPos", []]];
if (_mission == "") exitWith {
    [LLSTRING(NoFdcOrders)] call ace_common_fnc_displayTextStructured;
};

// the round; selecting it also fills the fuze list
private _ammoIndex = -1;
for "_i" from 0 to (lbSize 86001) - 1 do {
    if (lbData [86001, _i] == _magazine) exitWith {_ammoIndex = _i};
};
if (_ammoIndex == -1) exitWith {
    [format [LLSTRING(FdcRoundMissing), getText (configFile >> "CfgMagazines" >> _magazine >> "displayName")]] call ace_common_fnc_displayTextStructured;
};
lbSetCurSel [86001, _ammoIndex];
[controlNull, _ammoIndex] call FUNC(onSelectAmmo);

// the charge of the firing line the FDC sent
private _line = [_vehicle] call EFUNC(common,getFireSolution);
_vehicle setVariable ["itc_land_currentChargeIndex", parseNumber (_line param [0, "1"]), true];
[0] call FUNC(changeCharge);

private _fuzeIndex = -1;
for "_i" from 0 to (lbSize 86004) - 1 do {
    if (lbData [86004, _i] == _fuzeMode) exitWith {_fuzeIndex = _i};
};
if (_fuzeIndex != -1) then {
    // a time fuze gets the fuze setting of the sent line, shown in the time field when the fuze is selected
    private _fuzeSetting = _line param [10, -1];
    if (_fuzeMode == "time" && {_fuzeSetting >= 0}) then {
        _vehicle setVariable ["itc_land_fuzeTime", parseNumber ([_fuzeSetting, 1, 1] call CBA_fnc_formatNumber), true];
    };
    lbSetCurSel [86004, _fuzeIndex];
    [controlNull, _fuzeIndex] call FUNC(onSelectFuze);
};

ctrlSetText [86022, str _count];

if ((getArray (configFile >> "CfgMagazines" >> _magazine >> "itc_land_guidance")) param [0, ""] == "gps_inertial" && {_targetPos isEqualTypeArray [0, 0, 0]}) then {
    ctrlSetText [86013, ([_targetPos] call ace_common_fnc_getMapGridFromPos) joinString ""];
    ctrlSetText [86015, str round (_targetPos # 2)];
};

[format [LLSTRING(FdcOrdersApplied), _mission]] call ace_common_fnc_displayTextStructured;
