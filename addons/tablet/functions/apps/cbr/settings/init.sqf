#include "..\..\..\..\script_component.hpp"

#include "..\..\..\BCS_idc_defines.hpp"
ctrlShow [13600, true];
ctrlSetText [10400, player getVariable ["itc_land_cobra_id",""]];
[_display, IDC_workspace_header, "Settings"] call FUNC(setText);
