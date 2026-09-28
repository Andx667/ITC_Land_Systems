#include "..\script_component.hpp"

#include "BCS_idc_defines.hpp"

params ["_display"];

[_display, IDC_header1, ""] call FUNC(setText);
[_display, IDC_header2, ""] call FUNC(setText);
[_display, IDC_workspace_header, ""] call FUNC(setText);

[_display, IDC_sidebar_button1, 1] call FUNC(setFade);
[_display, IDC_sidebar_button2, 1] call FUNC(setFade);
[_display, IDC_sidebar_button3, 1] call FUNC(setFade);
[_display, IDC_sidebar_button4, 1] call FUNC(setFade);
[_display, IDC_sidebar_button5, 1] call FUNC(setFade);

[_display, IDC_fire_mission_list, 1] call FUNC(setFade);

[_display, 15010, 1] call FUNC(setFade);
[_display, 15011, 1] call FUNC(setFade);
