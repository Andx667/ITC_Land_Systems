#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Opens the tablet dialog and sets up a per-frame handler that drives the
 * tablet's rendering and app/page switching for the current vehicle for
 * as long as the dialog stays open.
 *
 * Arguments:
 * 0: Tablet weapon config class name <String>
 * 1: Unit using the tablet <Object> (default: player)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["itc_land_tablet_bcs"] call itc_land_tablet_fnc_open
 *
 * Public: No
 */

params ["_tabletClass",["_tabletOwner",player]];
createDialog "itc_land_tablet";

ITC_CURVEHICLE
private _display = findDisplay 32562;
if(!(_vehicle isKindOf "Man")) then {
  //_tabletClass = (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "itc_land" >> "tablet")  call BIS_fnc_getCfgData;
};
_vehicle setVariable ["apps", (configFile >> "CfgWeapons" >> _tabletClass >> "apps")  call BIS_fnc_getCfgData];
//_vehicle setVariable ["app", (_vehicle getVariable "apps") # 0];
if(isNil{_vehicle getVariable "app"}) then {
  _vehicle setVariable ["app", "home"];
};
private _page = if(isNil{_vehicle getVariable "page"}) then [{""},{"OPEN"}];
[{
  _this select 0 params ["_display","_vehicle", "_app", "_page"];
  if(!dialog || !alive player) then { //ensure player is alive and dialog is open
    [_this select 1] call CBA_fnc_removePerFrameHandler;
  };

  [_display] call FUNC(render);

  if(_vehicle getVariable "app" != _app) then { //check if app switched
    [_display] call FUNC(clear); //clear app pages
    if(_app != "") then { //clear the previous app if it existed
      [_display] call FUNC(appClear); //clear app pages
    };
    _app = _vehicle getVariable "app"; //switch the app variable
    [_app] call FUNC(compileApp);
    private _newPage = [_display] call itc_land_tablet_fnc_appInit; //initialize the new app
    if(_page != "OPEN") then { //this makes sure the init page isn't loaded when you're re-opening an already running tablet
      _vehicle setVariable ["page", _newPage];
    };
  };
  [_display] call itc_land_tablet_fnc_appRender; //render the app

  if(_vehicle getVariable "page" != _page) then { //check if page switched
    _page = _vehicle getVariable "page"; //switch the app variable
    [_display] call FUNC(appClear); //clear app pages
    if(_page != "") then { //if there's a page, initlialize it
      [_app,_page] call FUNC(compilePage);
      [_display] call itc_land_tablet_fnc_pageInit; //initialise the new page
    };
  };
  if(_page != "") then { //if there's a page, render it
    [_display] call itc_land_tablet_fnc_pageRender; //render the page
  };
  (_this select 0) set [2, _app];
  (_this select 0) set [3, _page];
}, 0, [_display, _vehicle, "", _page]] call CBA_fnc_addPerFrameHandler;
