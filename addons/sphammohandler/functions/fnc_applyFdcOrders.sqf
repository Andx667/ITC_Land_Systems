#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The classic ammunition handler's FDC ORDERS: fills in the fire orders the FDC sent
 * (common_fnc_getFdcOrders): round, charge, fuze (a time fuze with the line's fuze setting),
 * count and GPS target. The crew still checks them, then APPLY SETTINGS and LOAD, and lays the gun.
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
private _rounds = [];
for "_i" from 0 to (lbSize 86001) - 1 do {_rounds pushBack lbData [86001, _i]};
private _orders = [_vehicle, _rounds] call EFUNC(common,getFdcOrders);
if (_orders isEqualTo createHashMap) exitWith {
    [LLSTRING(NoFdcOrders)] call ace_common_fnc_displayTextStructured;
};
if ((_orders get "round") == -1) exitWith {
    [format [LLSTRING(FdcRoundMissing), getText (configFile >> "CfgMagazines" >> (_orders get "magazine") >> "displayName")]] call ace_common_fnc_displayTextStructured;
};

// the round; selecting it also fills the fuze list
lbSetCurSel [86001, _orders get "round"];
[controlNull, _orders get "round"] call FUNC(onSelectAmmo);
_vehicle setVariable ["itc_land_currentChargeIndex", _orders get "charge", true];
[0] call FUNC(changeCharge);
if ((_orders get "fuze") != -1) then {
    // shown in the time field when the fuze is selected
    if ((_orders get "time") != "") then {
        _vehicle setVariable ["itc_land_fuzeTime", parseNumber (_orders get "time"), true];
    };
    lbSetCurSel [86004, _orders get "fuze"];
    [controlNull, _orders get "fuze"] call FUNC(onSelectFuze);
};
ctrlSetText [86022, str (_orders get "count")];
if ((_orders get "grid") != "") then {
    ctrlSetText [86013, _orders get "grid"];
    ctrlSetText [86015, _orders get "alt"];
};

[format [LLSTRING(FdcOrdersApplied), _orders get "mission"]] call ace_common_fnc_displayTextStructured;
