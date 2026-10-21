#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Opens the tablet dialog and sets up a per-frame handler that drives the
 * tablet's rendering and app/page switching for the current vehicle for
 * as long as the dialog stays open.
 *
 * Arguments:
 * 0: Tablet weapon config class name <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["itc_land_tablet_fdc"] call itc_land_tablet_fnc_open
 *
 * Public: No
 */

params ["_tabletClass"];
createDialog "itc_land_tablet";

ITC_CURVEHICLE
private _display = findDisplay 32562;
private _apps = (configFile >> "CfgWeapons" >> _tabletClass >> "apps") call BIS_fnc_getCfgData;
_vehicle setVariable [QGVAR(apps), _apps];
// Resume the last app only if this tablet has it (another tablet may have been used here before)
private _lastApp = _vehicle getVariable [QGVAR(app), "home"];
if (_lastApp != "home" && {!(_lastApp in _apps)}) then {
    _vehicle setVariable [QGVAR(page), nil];
    _lastApp = "home";
};
_vehicle setVariable [QGVAR(app), _lastApp];
private _page = if (isNil{_vehicle getVariable QGVAR(page)}) then [{""},{"OPEN"}];
[{
    _this select 0 params ["_display","_vehicle", "_app", "_page"];
    if (isNull _display || {!alive player}) exitWith { //stop once the tablet is closed or the player died
        [_this select 1] call CBA_fnc_removePerFrameHandler;
        if (!isNull _display) then {_display closeDisplay 2};
    };

    [_display] call FUNC(render);

    if (_vehicle getVariable QGVAR(app) != _app) then { //check if app switched
        [_display] call FUNC(clear); //clear app pages
        if (_app != "") then { //clear the previous app if it existed
            [_display] call FUNC(appClear); //clear app pages
        };
        _app = _vehicle getVariable QGVAR(app); //switch the app variable
        [_app] call FUNC(compileApp);
        private _newPage = [_display] call itc_land_tablet_fnc_appInit; //initialize the new app
        if (_page != "OPEN") then { //this makes sure the init page isn't loaded when you're re-opening an already running tablet
            _vehicle setVariable [QGVAR(page), _newPage];
        };
    };
    [_display] call itc_land_tablet_fnc_appRender; //render the app

    if (_vehicle getVariable QGVAR(page) != _page) then { //check if page switched
        _page = _vehicle getVariable QGVAR(page); //switch the app variable
        [_display] call FUNC(appClear); //clear app pages
        if (_page != "") then { //if there's a page, initlialize it
            [_app,_page] call FUNC(compilePage);
            [_display] call itc_land_tablet_fnc_pageInit; //initialise the new page
        };
    };
    if (_page != "") then { //if there's a page, render it
        [_display] call itc_land_tablet_fnc_pageRender; //render the page
    };
    (_this select 0) set [2, _app];
    (_this select 0) set [3, _page];
    }, 0, [_display, _vehicle, "", _page]] call CBA_fnc_addPerFrameHandler;
