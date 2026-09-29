#define GENIDENT format["%1%2",GVAR(bcs_mission_code),[GVAR(bcs_mission_start),4] call cba_fnc_formatNumber];GVAR(bcs_mission_start) = GVAR(bcs_mission_start) + 1
#define EMPTYMISSION(IDENT) [IDENT, "newMission",[0,-1,"0","0","0","0",[0,0,0]],[0,0,0,0,0,""], 0, 0, 0];
#define MISSION private _mission = GVAR(bcs_missions) select GVAR(bcs_mission_index);if(isNil{_mission}) exitWith {(vehicle player) setVariable [QGVAR(page), "locStores"];}
#define SAVEMISSION(MSN) GVAR(bcs_missions) set [GVAR(bcs_mission_index), MSN]
#define MISSIONPARAMS _mission params ["_ident", "_page","_targetPage","_engagePage", "_curSolution", "_solutionLimit", "_shotEnd"]; \
_targetPage params ["_targetTypeIndex","_kpi","_in0","_in1","_in2","_in3","_tgtPos"]; \
_engagePage params ["_sheafTypeIndex","_quick","_sheafdir","_sheaflength","_shellTypeIndex","_magazineType"]
#define UINUMBER(IDC) parseNumber (ctrlText IDC)
#define UITEXT(IDC) ctrlText IDC
#define SETTEXT(IDC,TXT) (_display displayCtrl IDC) ctrlSetText TXT
#define FINDIDENT(ARR,IDENT) ARR findIf {_x # 0 == IDENT}
