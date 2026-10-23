#include "..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS (Battery Control System) tablet app. Sets the tablet header/sidebar
 * labels, fades in the sidebar buttons and fire mission list, and seeds the mission namespace
 * with default BCS variables (splash time, mission code, battery data, etc.) if not already set.
 * Connects the player to the datalink (once per unit, so again after a respawn): fire data sent
 * to the linked guns goes out with the player's ID as the origin, and the guns' shot reports
 * come back to it.
 *
 * Arguments:
 * 0: Tablet dialog display <Display>
 *
 * Return Value:
 * Name of the initial page to open for this app <String>
 *
 * Example:
 * [findDisplay 32562] call itc_land_tablet_fnc_appInit
 *
 * Public: No
 */

#include "..\..\BCS_idc_defines.hpp"
params ["_display"];

[_display, IDC_header1, "AIFMS"] call EFUNC(common,ctrlSetText);
[_display, IDC_header2, LLSTRING(Bcs_FdcSuite)] call EFUNC(common,ctrlSetText);

[_display, IDC_sidebar_button1, LLSTRING(Bcs_SettingsButton)] call EFUNC(common,ctrlSetText);
[_display, IDC_sidebar_button2, LLSTRING(Bcs_BatterySetupButton)] call EFUNC(common,ctrlSetText);
[_display, IDC_sidebar_button3, LLSTRING(Bcs_LocationStores)] call EFUNC(common,ctrlSetText);
//[_display, IDC_sidebar_button4, "Ammo Stores"] call EFUNC(common,ctrlSetText);
[_display, IDC_sidebar_button5, LLSTRING(Bcs_NewFiremission)] call EFUNC(common,ctrlSetText);

[_display, IDC_sidebar_button1, 0] call EFUNC(common,ctrlSetFade);
[_display, IDC_sidebar_button2, 0] call EFUNC(common,ctrlSetFade);
[_display, IDC_sidebar_button3, 0] call EFUNC(common,ctrlSetFade);
[_display, IDC_sidebar_button5, 0] call EFUNC(common,ctrlSetFade);

[_display, IDC_fire_mission_list, 0] call EFUNC(common,ctrlSetFade);

private _defaults = [
    [QGVAR(bcs_splash_time), 5], // the FDC calls SPLASH 5 s before impact
    [QGVAR(bcs_mission_code), "FM"],
    [QGVAR(bcs_mission_start), 1],

    [QGVAR(bcs_bty_name), ""],
    [QGVAR(bcs_bty_type), [0,"G155"]],
    [QGVAR(bcs_bty_guns), []],
    [QGVAR(bcs_locations), []],
    [QGVAR(bcs_missions), []],
    [QGVAR(bcs_mission_index), 0]
];
{
    if (isNil{missionNamespace getVariable (_x # 0)}) then {
        missionNamespace setVariable [_x # 0, _x # 1];
    };
} forEach _defaults;

if (missionNamespace getVariable [QGVAR(bcs_datalinkUnit), objNull] != ACE_player) then {
    GVAR(bcs_datalinkUnit) = ACE_player;
    [ACE_player, "", "object_register", true] call EFUNC(datalink,connect);
    // a linked gun reports the first shot of the fire data it got: that starts SHOT and SPLASH,
    // unless the mission is already counting down (the other guns of the salvo)
    [ACE_player, "fdc", "shot", {
        params ["", "_transmission"];
        (_transmission select 4) params [["_ident", "", [""]], ["_timeOfFlight", 0, [0]]];
        private _mission = GVAR(bcs_missions) param [GVAR(bcs_missions) findIf {_x # 0 == _ident}, []];
        if (_mission isEqualTo [] || {(_mission # 6) > time}) exitWith {};
        [_ident, _timeOfFlight] call FUNC(bcsShot);
        [format [LLSTRING(Bcs_ShotReported), _ident, round _timeOfFlight]] call ace_common_fnc_displayTextStructured;
    }] call EFUNC(datalink,registerEvent);
};

//itc_land_tablet_bcs_bty_guns = [["1","018058",[1800,5800,5],5,1],["2","018059",[1800,5900,5],5,1]];
//itc_land_tablet_bcs_missions = [["FM0001","solutionMission",[0,-1,"020035","5","0","0",[2000,3500,5]],["Parallel","ON",0,0],0,0,0]];
//itc_land_tablet_bcs_bty_name = "asdf";
//itc_land_tablet_bcs_bty_type = [3,"b_82"];
//itc_land_tablet_bcs_mission_index = 0;

"settings"
