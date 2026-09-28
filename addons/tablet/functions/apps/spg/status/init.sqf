#include "..\..\..\..\script_component.hpp"

params ["_display"];
#include "..\..\..\BCS_idc_defines.hpp"
ctrlShow [13420, true];
[_display, IDC_workspace_header, "Vehicle Status"] call FUNC(setText);
