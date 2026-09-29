#include "..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the CBR app: sets the static header text ("COBRA" / "Radar Suite"), un-fades and labels
 * the Map and Data sidebar buttons (the Settings and refresh-data buttons are currently disabled), and
 * selects "map" as the app's default landing page.
 *
 * Arguments:
 * 0: The tablet dialog's display <DISPLAY>
 *
 * Return Value:
 * The name of the page to load by default when the app opens <STRING>
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_appInit;
 *
 * Public: No
 */

params ["_display"];
#include "..\..\BCS_idc_defines.hpp"

[_display, IDC_header1, "COBRA"] call FUNC(setText);
[_display, IDC_header2, "Radar Suite"] call FUNC(setText);

//[_display, IDC_sidebar_button1, 0] call FUNC(setFade);
[_display, IDC_sidebar_button2, 0] call FUNC(setFade);
[_display, IDC_sidebar_button3, 0] call FUNC(setFade);
//[_display, IDC_sidebar_button1, "COBRA Settings"] call FUNC(setText);
[_display, IDC_sidebar_button2, "Map view"] call FUNC(setText);
[_display, IDC_sidebar_button3, "Data view"] call FUNC(setText);

//[_display, IDC_sidebar_button5, 0] call FUNC(setFade);
//[_display, IDC_sidebar_button5, "Refresh data"] call FUNC(setText);

/*
if(!(missionNamespace getVariable ["itc_land_cobra_app_hasInitialized",false])) then {
  [player, "cobra", "returnData", {
    params ["_target","_transmission"];
    _transmission params ["_destination","_origin","_header","_type","_data"];
    _data params ["_vehicle","_origins","_engagements","_activeShells"];
    _cobras = _target getVariable [QEGVAR(cobra,vehicles),[]];
    _target setVariable [QEGVAR(cobra,vehicles),_cobras + [_vehicle]];
    _target setVariable [QEGVAR(cobra,firingPositions),_origins];
    _target setVariable [QEGVAR(cobra,engagements),_engagements];
    _target setVariable [QEGVAR(cobra,activeShells),_activeShells];
  }] call EFUNC(datalink,registerEvent);

  [player, "cobra", "shellDetected", {
    params ["_target","_transmission"];
    _transmission params ["_destination","_origin","_header","_type","_data"];
    _data params ["_position","_tof"];
    _activeShells = _target getVariable [QEGVAR(cobra,activeShells),[]];
    _target setVariable [QEGVAR(cobra,activeShells),_activeShells + [[_position, _tof + time]]];
  }] call EFUNC(datalink,registerEvent);
};

itc_land_cobra_app_hasInitialized = true;
*/
"map"
