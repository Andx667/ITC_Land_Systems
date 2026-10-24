#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles interactions on the missile FCS page. On "calc" it computes the firing solutions on the entered
 * target grid/elevation for the selected rocket (tablet_fnc_fcsCalculate); on "prev"/"next" it steps
 * through them (tablet_fnc_fcsStep). On "setFG" it applies the selected fuze and, for GPS guided
 * rockets, the target (tablet_fnc_fcsApplyRocketSettings). On "fdcOrders" it fills in the FDC's
 * fire orders (common_fnc_getFdcOrders).
 *
 * Arguments:
 * 0: The interaction action identifier ("calc", "prev", "next", "setFG", "fdcOrders") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["calc"] call itc_land_tablet_fnc_pageInteract
 *
 * Public: No
 */

params ["_action"];
ITC_CURVEHICLE

switch (_action) do {
    case "calc": {
        [_vehicle, ctrlText 2400, parseNumber (ctrlText 2401), lbData [2402, lbCurSel 2402]] call FUNC(fcsCalculate);
    };
    case "prev": {[_vehicle, -1] call FUNC(fcsStep)};
    case "next": {[_vehicle, 1] call FUNC(fcsStep)};
    case "fdcOrders": {
        // fill in the FDC's fire orders: round, fuze (a time fuze with the line's fuze setting) and GPS target; APPLY stays with the crew
        private _rounds = [];
        for "_i" from 0 to (lbSize 2402) - 1 do {_rounds pushBack lbData [2402, _i]};
        private _orders = [_vehicle, _rounds] call EFUNC(common,getFdcOrders);
        if (_orders isEqualTo createHashMap) exitWith {
            [LLSTRING(Fcs_NoFdcOrders)] call ace_common_fnc_displayTextStructured;
        };
        if ((_orders get "round") == -1) exitWith {
            [format [LLSTRING(Fcs_FdcRoundMissing), getText (configFile >> "CfgMagazines" >> (_orders get "magazine") >> "displayName")]] call ace_common_fnc_displayTextStructured;
        };
        lbSetCurSel [2402, _orders get "round"];
        [2402, _orders get "round"] call FUNC(mlrsfci_onlblselchanged_roundType);
        if ((_orders get "fuze") != -1) then {
            if ((_orders get "time") != "") then {
                _vehicle setVariable ["itc_land_mlrsfci_fuzeTime", parseNumber (_orders get "time"), true];
            };
            lbSetCurSel [1904, _orders get "fuze"];
            [1904, _orders get "fuze"] call FUNC(mlrsfci_onlblselchanged_fuzemode);
        };
        if ((_orders get "grid") != "") then {
            ctrlSetText [1909, _orders get "grid"];
            ctrlSetText [1911, _orders get "alt"];
        };
        [format [LLSTRING(Fcs_FdcOrdersApplied), _orders get "mission"]] call ace_common_fnc_displayTextStructured;
    };
    case "setFG": {
        [_vehicle, lbData [2402, lbCurSel 2402], lbCurSel 1904, parseNumber (ctrlText 1906), ctrlText 1909, parseNumber (ctrlText 1911)] call FUNC(fcsApplyRocketSettings);
    };
};
