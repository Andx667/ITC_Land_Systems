#include "..\..\..\script_component.hpp"

params ["_display"];
{
  ctrlShow [_x, false];
} forEach [13301];

[_display, 15010, 1] call FUNC(setFade);
[_display, 15011, 1] call FUNC(setFade);
