#include "..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles BCS app-level sidebar interactions: switching between the settings, setup and
 * locStores pages, creating a new fire mission (side5), and selecting a fire mission from
 * the mission list (sideList) to jump to its current page.
 *
 * Arguments:
 * 0: Action identifier ("side1", "side2", "side3", "side5" or "sideList") <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["sideList"] call itc_land_tablet_fnc_appInteract
 *
 * Public: No
 */

params ["_action"];
#include "bcsDefines.hpp"
ITC_CURVEHICLE
switch(_action) do {
  case "side1": {
    _vehicle setVariable ["page", "settings"];
  };
  case "side2": {
    _vehicle setVariable ["page", "setup"];
  };
  case "side3": {
    _vehicle setVariable ["page", "locStores"];
  };
  case "side5": {
    private _ident = GENIDENT;
    private _newMission = EMPTYMISSION(_ident);
    bcs_missions pushBack _newMission;
    bcs_mission_index = (count bcs_missions) - 1;
    if(_vehicle getVariable "page" == "newMission") then {
      [findDisplay 32562] call itc_land_tablet_fnc_pageInit;
    } else {
      _vehicle setVariable ["page", "newMission"];
    };
  };
  case "sideList": {
    bcs_mission_index = lbCurSel 15114;
    MISSION;
    if(_vehicle getVariable "page" == _mission # 1) then {
      [findDisplay 32562] call itc_land_tablet_fnc_pageInit;
    } else {
      _vehicle setVariable ["page", _mission # 1];
    };
  };
};
