#include "..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS (Battery Control System) tablet app. Sets the tablet header/sidebar
 * labels and fades in the sidebar buttons and fire mission list; the BCS itself (defaults,
 * datalink, a handed-over target) starts in tablet_fnc_bcsInit, shared with the HTML tablet.
 *
 * Arguments:
 * 0: Tablet dialog display <Display>
 *
 * Return Value:
 * Name of the initial page to open for this app: settings, or the engagement page of a fire mission
 * made from a target another app handed over (itc_land_tablet_bcs_pendingTarget, COBRA counter-fire) <String>
 *
 * Example:
 * [findDisplay 32562] call itc_land_tablet_fnc_appInit
 *
 * Public: No
 */

#include "..\..\BCS_idc_defines.hpp"
#include "bcsDefines.hpp"
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

// defaults, the datalink and a handed-over target: shared with the HTML tablet
[] call FUNC(bcsInit)
