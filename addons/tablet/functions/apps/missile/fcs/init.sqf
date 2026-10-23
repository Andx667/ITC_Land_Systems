#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the missile FCS (fire control) page: shows its controls, sets the workspace header,
 * resets the local targeting listbox, initializes the vehicle's stored firing-solution variables if unset,
 * restores any previously entered target grid/elevation, builds the ammunition combo box from the vehicle's
 * loaded magazines, and renders the current firing solution (or LLSTRING(Fcs_NoSolution) if none exists) into the solution display.
 *
 * Arguments:
 * 0: The tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_pageInit
 *
 * Public: No
 */

#include "..\..\..\BCS_idc_defines.hpp"
params ["_display"];
ITC_CURVEHICLE
ctrlShow [13701, true];
[_display, IDC_workspace_header, LLSTRING(Fcs_Header)] call EFUNC(common,ctrlSetText);
//(_display displayCtrl 1501) lbAdd "MANUAL TARGETING";
lbClear (_display displayCtrl 1512);
(_display displayCtrl 1512) lbAdd LLSTRING(Fcs_LocalTargeting);
(_display displayCtrl 1512) lbSetCurSel 0;
//[_display,1] call FUNC(fcimode_onlblselchanged);

if (isNil{_vehicle getVariable "itc_land_tablet_fcs_solutions"}) then {
    _vehicle setVariable ["itc_land_tablet_fcs_solutions", [], true];
};
if (isNil{_vehicle getVariable "itc_land_tablet_fcs_solutions_index"}) then {
    _vehicle setVariable ["itc_land_tablet_fcs_solutions_index", 0, true];
};

//Clear or populate local FCS inputs and solution output
if ((!(isNil {_vehicle getVariable "itc_land_tablet_fcs_tgtgrid"}))&&(!(isNil {_vehicle getVariable "itc_land_tablet_fcs_tgtelev"})) ) then {
    ctrlSetText [2400,_vehicle getVariable "itc_land_tablet_fcs_tgtgrid"];
    ctrlSetText [2401,str(_vehicle getVariable "itc_land_tablet_fcs_tgtelev")];
} else {
    ctrlSetText [2400,""];
    ctrlSetText [2401,""];
};
private _magazineTypes = (((
    "(getText (_x >> ""weaponClass"")) == ((weapons vehicle player)#0)"
    configClasses
    (configFile >> "itc_land_ballistics" >> "batteryTypes")
    ) # 0) >> "ammunition") call BIS_fnc_getCfgData;
private _magazines = [];
{
    if (_x in _magazineTypes) then {
        _magazines pushBack _x;
    };
} forEach ( magazines _vehicle );


private _magazineNames = _magazines apply {
    getText (configFile >> "CfgMagazines" >> _x >> "displayName");
};

[2402,_magazineNames,0,_magazines] call FUNC(fillComboBox);
[2402, lbCurSel 2402] call FUNC(mlrsfci_onlblselchanged_roundType);

// the readout is drawn by render.sqf; forget what it last drew so it draws on this page again
_display setVariable [QGVAR(fcsShown), nil];


/*
if (isNil "itc_land_fcimode") then {
    lbSetCurSel [1501,0];
    [_display,0] call FUNC(fcimode_onlblselchanged);
} else {
    lbSetCurSel [1501,itc_land_fcimode # 0];
    [_display,itc_land_fcimode # 0] call FUNC(fcimode_onlblselchanged);
};
*/
//(_display displayCtrl 1500) lbAdd "G: 0101   CH: 2    AZ: 800    DF: 3982    QD: 368    TOF:23.31";
