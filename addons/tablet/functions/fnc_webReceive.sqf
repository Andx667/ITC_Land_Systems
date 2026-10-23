#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Handles a message from the HTML tablet (A3API.SendAlert, the control's JSDialog event): JSON
 * {a: action, v: value, k: view key, f: {field: value}}. The field values are stored in the form
 * (tablet_fnc_webForm) when they belong to the view shown, then the action runs. Anything in the
 * page can send anything, so every value is checked here and in the app handlers.
 *   hello          the page has loaded: send the full state
 *   key    i       a key on the frame: APP 1-2 (the tablet's apps; a key without one does nothing), 3 home (Input Lock); APP 3 has no function
 *   page   name    a sidebar page of the app shown
 *   mapRect [x,y,w,h]  where the page has the map's slot, fractions of the page ([]: no map)
 *   close          close the tablet
 *   classic        close this and open the classic tablet where this one is
 *   anything else  the app's handler (tablet_fnc_webAction*)
 *
 * Arguments:
 * 0: Browser control <CONTROL>
 * 1: Message <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ctrl, "{""a"":""key"",""v"":1}"] call itc_land_tablet_fnc_webReceive
 *
 * Public: No
 */

params ["_ctrl", "_message"];

if (isNil QGVAR(web)) exitWith {};
private _msg = fromJSON _message;
if !(_msg isEqualType createHashMap) exitWith {};
private _action = _msg getOrDefault ["a", ""];
if !(_action isEqualType "") exitWith {};
private _value = _msg getOrDefault ["v", nil];
private _fields = _msg getOrDefault ["f", createHashMap];
if !(_fields isEqualType createHashMap) then {_fields = createHashMap};

// values typed into this view: kept, whatever the action does with them
if ((_msg getOrDefault ["k", ""]) isEqualTo (GVAR(web) get "formKey")) then {
    private _form = GVAR(web) get "form";
    {
        if (_y isEqualType "" || {_y isEqualType 0}) then {_form set [_x, _y]};
    } forEach _fields;
};

private _vehicle = [] call EFUNC(common,getCurVehicle);
private _apps = getArray (configFile >> "CfgWeapons" >> (GVAR(web) get "tablet") >> "apps");
private _app = _vehicle getVariable [QGVAR(app), "home"];
private _shared = getText (configFile >> "itc_land" >> "apps" >> _app >> "sharedApp");
private _appType = [_app, _shared] select (_shared != "");

// the ammunition handler: its own actions (sphammohandler_fnc_webAction) besides hello, close and classic
if ((GVAR(web) get "kind") == "ammo" && {!(_action in ["hello", "close", "classic"])}) exitWith {
    [_vehicle, _action, _value] call EFUNC(sphammohandler,webAction);
    [_ctrl] call FUNC(webSend);
};

switch (_action) do {
    case "hello": {
        GVAR(web) set ["sent", ""];
    };
    case "key": {
        if (_value isEqualTo 3) exitWith {["home"] call FUNC(webStartApp)};
        if (_value isEqualType 0 && {_value in [0, 1]} && {_value < count _apps}) then {
            [_apps # _value] call FUNC(webStartApp);
        };
    };
    case "page": {
        private _pages = switch (_appType) do {
            case "artillery": {["fcs", "status"]};
            case "bcs": {["settings", "setup", "locStores"]};
            case "cbr": {["map", "data"]};
            default {[]};
        };
        if (_value isEqualType "" && {_value in _pages}) then {
            _vehicle setVariable [QGVAR(page), _value];
        };
    };
    case "mapRect": {
        GVAR(web) set ["mapRect", [[], _value] select (_value isEqualTypeArray [0, 0, 0, 0])];
        [_ctrl] call FUNC(webPlaceMap);
    };
    case "close": {
        // closing the browser inside its own event is not safe: next frame
        [{
            params ["_ctrl"];
            if (!isNull _ctrl) then {(ctrlParent _ctrl) closeDisplay 2};
        }, [_ctrl]] call CBA_fnc_execNextFrame;
    };
    case "classic": {
        [{
            params ["_ctrl", "_tabletClass", "_kind"];
            if (!isNull _ctrl) then {(ctrlParent _ctrl) closeDisplay 2};
            if (_kind == "ammo") then {createDialog "ITC_Land_SPHammohandler"} else {[_tabletClass, true] call FUNC(open)};
        }, [_ctrl, GVAR(web) get "tablet", GVAR(web) get "kind"]] call CBA_fnc_execNextFrame;
    };
    default {
        switch (_appType) do {
            case "artillery": {[_vehicle, _app, _action, _value] call FUNC(webActionArtillery)};
            case "bcs": {[_vehicle, _action, _value] call FUNC(webActionBcs)};
            case "cbr": {[_vehicle, _action, _value] call FUNC(webActionCbr)};
        };
    };
};

[_ctrl] call FUNC(webSend);
