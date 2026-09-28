#include "..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Renders the BCS app's sidebar fire mission list, showing each mission's name and its
 * current SPLASH/SHOT countdown status where applicable.
 *
 * Arguments:
 * 0: Tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562] call itc_land_tablet_fnc_appRender
 *
 * Public: No
 */

params ["_display"];

_fireMissionStrings = bcs_missions apply {
  if(_x # 6 > time) then {
    _text = if(time > (_x # 6) - bcs_splash_time) then [{"SPLASH"},{"SHOT"}];
    format["%1 %2", _x # 0, _text];
  } else {
    format["%1", _x # 0];
  };
};
[15114, _fireMissionStrings, -1] call FUNC(fillComboBox);
