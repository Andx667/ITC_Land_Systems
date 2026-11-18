# Tablet

`itc_land_tablet`: The tablet items, the app framework and the [tablet apps](../../docs/usage.md#tablets).

## Dependencies

- ITC: `itc_land_common`, `itc_land_bcs`, `itc_land_datalink`
- ACE: `ace_interaction`, `ace_interact_menu`, `ace_common`, `ace_huntir`

## Files

- `CfgMisc.hpp`
- `CfgVehicles.hpp`
- `CfgWeapons.hpp`
- `UIConfig/defines.hpp`
- `UIConfig/tablet.hpp`
- `UIConfig/tablet_web.hpp`

## Settings

CBA settings in `initSettings.inc.sqf`: `itc_land_tablet_webTablet`.

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_bcsAdjustTarget` |  | An observer's correction to the BCS fire mission's target: add/drop, left/right and up/down along the observer-target direction (bcs_fnc_adjustGrid). |
| `fnc_bcsEndMission` |  | End of mission for the BCS fire mission shown: the linked guns' fire orders for it are cleared over the datalink, its target is optionally recorded as a known point, and the mission is deleted. |
| `fnc_bcsFillFuzes` |  | Fills a list or combo box with the fuze modes of a round (its itc_land_fuze in ITC_Land_CfgFuzes), each entry's data being the mode ("pd", "prox", "time", "delay"). |
| `fnc_bcsInit` |  | Starts the BCS for the classic and the HTML tablet: seeds the mission namespace with default BCS variables (splash time, mission code, battery data, etc.) if not already set, and connects the player to the datalink (once per unit, so again after a respawn): fire data sent to the linked guns goes out with the player's ID as the origin, and the guns' shot reports come back to it. |
| `fnc_bcsLinkGun` |  | Links a gun on the datalink to the BCS battery under the next free gun number (tablet_fnc_bcsNextId); its position, altitude and direction come from the vehicle (bcs_fnc_refreshLinkedGuns). |
| `fnc_bcsListenTargets` |  | Listens on the datalink for the targets observers send from the ITC optics (to every FDC), from the start of the mission and for every player: each becomes a Location Stores entry (TGT01, TGT02, ...), so an FDC that opens the BCS only later still has the targets sent before. |
| `fnc_bcsNextId` |  | The ID for the next BCS gun or known point: the lowest free one, so new entries need no typing and do not overwrite one (an ID that exists updates that entry). |
| `fnc_bcsRecordPoint` |  | Records a position as a known point of the BCS location stores (tablet_fnc_bcsSaveLocation): an ended mission's target, a COBRA firing position, an observer's target. |
| `fnc_bcsSaveGun` |  | A gun of the BCS battery by hand: number, grid, altitude and direction. |
| `fnc_bcsSaveLocation` |  | A known point of the BCS location stores: ID, grid, altitude and friendly. |
| `fnc_bcsSendFireData` |  | The BCS fire commands to the guns (SEND ADJ / SEND FFE): the firing line of each gun for the selected battery solution goes over the datalink to its linked gun's sight, with the round, count, fuze and target as fire orders. |
| `fnc_bcsSetEngagement` |  | The BCS fire mission's method of engagement (the engagement page's NEXT): sheaf, round of the active battery type, rounds per gun and fuze, then on to the solutions. |
| `fnc_bcsSetTarget` |  | The BCS fire mission's target (the new mission page's NEXT): its position from the target type and inputs (bcs_fnc_calculateTarget), then on to the engagement. |
| `fnc_bcsShot` |  | Records that a BCS fire mission was fired: its impact time (now plus the time of flight) starts the SHOT/SPLASH countdown, and Alert To Splash seconds before impact a beep and a hint warn the FDC, also with the tablet closed (right away if the time of flight is shorter). |
| `fnc_cbrDrawMap` |  | Draws the COBRA picture on a map control (classic and HTML tablet): each COBRA radar with its 44 degree search sector, the firing positions it located (with their round count) and the predicted impact points of the shells still in flight (with the seconds to impact). |
| `fnc_clear` |  | Clears the tablet header/workspace text fields and hides (fades out) the sidebar buttons, fire mission list and controls 15010/15011. |
| `fnc_compileApp` |  | Compiles the init, clear, interact and render scripts for the given app and assigns them to the global app function handles used by the tablet's per-frame render loop. |
| `fnc_compilePage` |  | Compiles the init, interact and render scripts for the given app/page combination and assigns them to the global page function handles used by the tablet's per-frame render loop. |
| `fnc_compileScript` |  | Compiles a tablet app/page script, reusing the compiled code on later calls. |
| `fnc_fcimode_onlblselchanged` |  | Listbox selection-changed handler for the FCI mode selector. |
| `fnc_fcsApplyRocketSettings` |  | The MLRS FCI's APPLY: the fuze mode and setting of the rockets (common_fnc_setFuzeSelection, common_fnc_resolveFuzeSetting) and the target of a GPS guided rocket. |
| `fnc_fcsCalculate` |  | The FCI's CALCULATE (SPG and MLRS): the firing solutions of the vehicle's gun on the target grid and elevation for a round, within the elevations the gun can lay, stored on the vehicle (itc_land_tablet_fcs_solutions) with the first one selected. |
| `fnc_fcsSolutionText` |  | Builds the SPG and MLRS apps' readout of the vehicle's selected fire solution: where it came from when the FDC sent it (mission, ADJ/FFE, round), then solution number, charge, azimuth, deflection, quadrant, time of flight, time fuze setting (rounds with a time fuze), maximum ordinate and distance, or NO SLN. |
| `fnc_fcsStep` |  | Steps the FCI's selected firing solution (the one the gunner sight shows) one back or on, within the solutions of the last calculation (tablet_fnc_fcsCalculate). |
| `fnc_fillComboBox` |  | Clears and repopulates a listbox/combobox control with the given entries, selects an index, and optionally attaches per-entry data. |
| `fnc_interact` |  | Handles a tablet interaction. |
| `fnc_mlrsfci_onlblselchanged_fuzemode` |  | Listbox selection-changed handler for the MLRS FCI fuze mode selector. |
| `fnc_mlrsfci_onlblselchanged_roundType` |  | Listbox selection-changed handler for the MLRS FCI round type selector. |
| `fnc_open` |  | Opens the tablet dialog and sets up a per-frame handler that drives the tablet's rendering and app/page switching for the current vehicle for as long as the dialog stays open. |
| `fnc_openVehicleTablet` |  | Looks up the tablet mounted on the given vehicle and opens it, if one is defined. |
| `fnc_render` |  | Updates the tablet screen's fade level (control 15117) to match the current ambient brightness, simulating screen backlight visibility. |
| `fnc_resolveAppFile` |  | Finds the script file of a tablet app or page. |
| `fnc_vehicleHasTablet` |  | Checks whether the given vehicle has a mounted tablet defined in its config. |
| `fnc_webActionArtillery` |  | The HTML tablet's SPG and MLRS actions, as the classic FCI page's (the form holds the values the page sent, see tablet_fnc_webReceive): artCalc       firing solutions on the target grid and elevation for the selected round artStep d     the solution shown in the gunner sight, one back (-1) or on (1) artApplyCalc  MLRS: artApply, then artCalc: the rockets' settings and the solution of one round artRound      another round (the MLRS's fuze modes follow it) artFuze       another fuze mode artApply      MLRS: the fuze and guidance of the rockets artFdcOrders  MLRS: fill in the FDC's round, fuze and GPS target |
| `fnc_webActionBcs` |  | The HTML tablet's BCS actions, as the classic BCS pages' (the form holds the values the page sent, see tablet_fnc_webReceive; tablet_fnc_webViewBcs shows the result): bcsNewMission, bcsMission i     a new fire mission, or the selected one on its page bcsSettingsSave                 alert to splash, mission code and number bcsSetupSave/AddGun/RemoveGun/Link   battery callsign and type, guns by hand or linked bcsLocAdd/Remove                location stores bcsNmLoad/Save                  the target: a known point's grid, then on to the engagement bcsEngAmmo/Back/Save            the engagement: round (its fuzes), sheaf, fire orders bcsSolStep d, bcsAdjGun i, bcsShot, bcsSendAdj/Ffe, bcsAdjust, bcsSolBack, bcsEom, bcsEomSave solutions: one back or on, the adjusting gun, SHOT, fire commands (adjust fire with one round), end of mission bcsEngSheaf, bcsNmType        a choice that changes the page (only stored) bcsAdjSave/Back                 an adjustment to the target The BCS data changes go through the tablet_fnc_bcs* functions the classic pages use as well. |
| `fnc_webActionCbr` |  | The HTML tablet's COBRA actions, as the classic data page's: cbrSave         the selected firing position into the BCS location stores cbrCounterFire  a BCS fire mission on it (the BCS opens on its engagement) |
| `fnc_webBlock` |  | A workspace block of the HTML tablet (tablet.html draws it by its type): "section", "fields", "bar", "buttons", "list", "kv", "stepper", "note", "row", "col", "tiles", "map", "image". |
| `fnc_webButton` |  | A button of the HTML tablet (a "buttons" block item or a sidebar button): sends its action, value and the given fields' values to tablet_fnc_webReceive. |
| `fnc_webCheck` |  | The extras of an HTML tablet text box (tablet_fnc_webField) for a kind of value: the check the page makes before a button sends it, and the unit shown after the box. |
| `fnc_webField` |  | A form field of the HTML tablet (a "fields" block item): a text box, or a select box with options. |
| `fnc_webForm` |  | The values of the HTML tablet's form fields for the view shown (its key: app, page and fire mission). |
| `fnc_webFormChanged` |  | Tells the HTML tablet that script changed its form values (tablet_fnc_webForm): the page drops what was typed and shows them. |
| `fnc_webFormValue` |  | A value of the HTML tablet's form (tablet_fnc_webForm), as the page sent it: a text box as text, a select box's, list's or checkbox's index. |
| `fnc_webNotice` |  | Shows the result of an action in the HTML tablet or ammunition handler, at the top of the page for 8 s (tablet_fnc_webState puts it in the view), instead of an ACE hint beside the tablet. |
| `fnc_webOpen` |  | Opens the tablet in HTML (itc_land_tablet_web, a CT_WEBBROWSER control, Arma 3 2.20+; the setting "Tablet in HTML" makes tablet_fnc_open come here): loads html\tablet.html, wires the page's messages to tablet_fnc_webReceive, draws the COBRA picture on the native map control, and sends the page the state (tablet_fnc_webState) twice a second while it is open. |
| `fnc_webPlaceMap` |  | Places the HTML tablet's native map control (COBRA map) over the slot the page reported (GVAR(web) "mapRect", fractions of the page), or hides it when the page has no map slot. |
| `fnc_webReceive` |  | Handles a message from the HTML tablet (A3API.SendAlert, the control's JSDialog event): JSON {a: action, v: value, k: view key, f: {field: value}}. |
| `fnc_webSend` |  | Sends the HTML tablet its state (webState) when it changed since the last send: JSON, base64 encoded so it can sit in the JavaScript source, through ctrlWebBrowserAction "ExecJS". |
| `fnc_webStartApp` |  | Switches the HTML tablet to an app, on its first page (what the classic tablet's app init returns): home on its app list, the SPG and MLRS apps on the FCI page, the BCS on its settings (or a handed-over target's fire mission, tablet_fnc_bcsInit), COBRA on its map. |
| `fnc_webState` |  | Builds the state the HTML tablet draws (tablet.html): the view of the app shown, from its tablet_fnc_webView* function: header, sidebar, fire mission list and the workspace blocks, with the form values (tablet_fnc_webForm) and the view key the page keeps its drafts for, the last action's result (tablet_fnc_webNotice) and the status bar (datalink ID or vehicle, time). |
| `fnc_webViewArtillery` |  | The HTML tablet's SPG and MLRS apps (the classic "artillery" app with the spg and missile FCI pages): the FCI page takes the target grid, elevation and round, computes the firing solutions for the vehicle (tablet_fnc_webActionArtillery) and shows the selected one, or the FDC's fire data; the MLRS also sets the fuze and guidance of its rockets, applied together with the calculation so the two cannot differ, and fills in the FDC's orders. |
| `fnc_webViewBcs` |  | The HTML tablet's BCS, page by page as the classic one (the same data, the actions in tablet_fnc_webActionBcs): settings, battery setup (the battery, its guns by hand or linked over the datalink), the known points, and a fire mission's target, engagement, solutions and adjustment, in the order of a fire mission: call for fire, target, method of engagement, fire commands to the guns (with the message to the observer), adjust fire, fire for effect, end of mission. |
| `fnc_webViewCbr` |  | The HTML tablet's COBRA app: the map (a native map control over the page's map slot, drawn by tablet_fnc_cbrDrawMap) and the data page with the located firing positions, to save in the BCS location stores or to open a counter-fire mission on (tablet_fnc_webActionCbr). |
| `fnc_webViewHome` |  | The HTML tablet's home screen: the tablet's apps on APP 1-3, with the vehicle systems each needs, and the logo, as on the classic tablet's app list. |

Tablet apps live in `functions/apps/<app>/` (init, render, interact, clear) with one subfolder per page: `artillery`, `bcs`, `cbr`, `home`, `missile`, `sadl`, `spg`.
