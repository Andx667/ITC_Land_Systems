#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS engageMission page: shows the engageMission workspace panel, sets its
 * header to the current mission's identifier, and fills the shell type, sheaf type and
 * quick/normal fire combo boxes from the mission's stored engagement data and battery type.
 *
 * Arguments:
 * 0: Tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562] call itc_land_tablet_fnc_pageInit
 *
 * Public: No
 */

params ["_display"];
#include "..\..\..\BCS_idc_defines.hpp"
#include "..\bcsDefines.hpp"
MISSION;MISSIONPARAMS;
ctrlShow [13505, true];
[_display, IDC_workspace_header, format [LLSTRING(Bcs_Engagement),_ident]] call EFUNC(common,ctrlSetText);

// the active battery type's ammunition, by name: Bty Setup need not have been opened in this session
private _shellTypes = getArray (configFile >> "itc_land_ballistics" >> "batteryTypes" >> (GVAR(bcs_bty_type) # 1) >> "ammunition");
private _shellNames = _shellTypes apply {((configFile >> "CfgMagazines" >> _x >> "displayName")  call BIS_fnc_getCfgData)};
[7100,_shellNames,_shellTypeIndex,_shellTypes] call FUNC(fillComboBox);

[7101,["Parallel","Converged","Linear","Open","Special"],_sheafTypeIndex] call FUNC(fillComboBox);

[7401,["On","Off"],_quick] call FUNC(fillComboBox);

// fire orders: the selected round's fuze modes and the round count
[7102, _shellTypes param [_shellTypeIndex, ""], _fuzeMode] call FUNC(bcsFillFuzes);
ctrlSetText [7404, str _roundCount];
