# SPH Ammo Handler

`itc_land_sphammohandler`: The [ammunition handler](../../docs/systems/artillery.md#ammunition-handler).

## Dependencies

- ITC: `itc_land_veh_weapons`, `itc_land_common`
- ACE: `ace_interaction`

## Files

- `CfgWeapons.hpp`
- `dialogConfig.hpp`

## CBA events

Internal events this addon handles (raised with `CBA_fnc_*Event`):

- `itc_land_sphammohandler_changeMagazine` (`XEH_postInit.sqf`)

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_applyFdcOrders` |  | The classic ammunition handler's FDC ORDERS: fills in the fire orders the FDC sent (common_fnc_getFdcOrders): round, charge, fuze (a time fuze with the line's fuze setting), count and GPS target. |
| `fnc_applyLoaderSettings` |  | Applies the ammunition handler's settings, the ones the loader works with: the prepared round (itc_land_sphammohandler_currentMagInfo) with its charge, the selected fuze mode (common_fnc_setFuzeSelection) with its setting, the guidance (GPS target or laser codes) and the round count, stored on the vehicle as itc_land_sphammohandler_sphloadersettings. |
| `fnc_applySettings` |  | The classic ammunition handler's APPLY SETTINGS: applies the dialog's fuze, guidance and count (sphammohandler_fnc_applyLoaderSettings), shows the applied settings in the readout and enables the Load button. |
| `fnc_canOpen` |  | Condition of the ammunition handler's ACE self action: the gunner, or the loader where the vehicle has a loader seat (see getLoader). |
| `fnc_changeCharge` |  | Adjusts the vehicle's currently selected propellant charge index by the given increment, clamping the result between 1 and the maximum charge index defined for the currently selected ammunition, and updates the charge label in the SPH ammo-loader dialog. |
| `fnc_changeMagazine` |  | Requests a magazine change on the SPH gun. |
| `fnc_fillAmmoList` |  | Clears and repopulates the ammo listbox in the SPH ammo-loader dialog with the consolidated counts of each magazine currently carried by the vehicle that is flagged to be counted by the ammo handler, storing each entry's magazine classname as its listbox data. |
| `fnc_fillFuzeList` |  | Clears and repopulates the fuze combobox in the SPH ammo-loader dialog with the fuze modes and descriptions available for the currently selected ammunition's fuze type, storing each entry's fuze mode class as its listbox data. |
| `fnc_firedEH` |  | "Fired" event handler for the SPH gun. |
| `fnc_getLoader` |  | Returns the unit in the vehicle's loader seat: the turret named by itc_land >> loaderTurret (its config class name, as turret paths shift with the host mod's turret order). |
| `fnc_loadGun` |  | Loads or unloads the SPH's gun magazine according to the vehicle's configured loader type (manual, semi-automatic, automatic or muzzle loaded) and current autoloader status, running the load/unload sequence asynchronously and updating the autoloader status (and its displayed text) through each step, from pulling/ramming the shell and inserting the charge to closing the breech, or from safing the weapon to removing and stowing the round. |
| `fnc_onChangeMagazine` |  | Handles the changeMagazine event on the machine where the SPH's main turret is local and applies the requested magazine change to that turret. |
| `fnc_onLoad` |  | Runs once the SPH ammo-loader dialog has been created. |
| `fnc_onSelectAmmo` |  | RscListBox onLBSelChanged handler for the SPH ammo-loader's ammo listbox. |
| `fnc_onSelectFuze` |  | RscListBox onLBSelChanged handler for the SPH ammo-loader's fuze combobox. |
| `fnc_open` |  | Opens the ammunition handler: in HTML with the setting "Tablet in HTML" (the tablet's web page as a panel, sphammohandler_fnc_webView/webAction), else the classic dialog. |
| `fnc_runSequence` |  | Runs a list of steps one after another in the unscheduled environment. |
| `fnc_tubeHeat` |  | Mortar tube heat, counted in rounds: each round adds one, the tube sheds the sustained rate (itc_land >> mortarSustainedRate, rounds a minute, default 4). |
| `fnc_updateStatus` |  | Updates the SPH ammo-loader dialog's Apply/Load/Unload buttons, status label, and (when a load or unload cycle has just pulled/stowed a round) the ammo listbox selection, to reflect the vehicle's current autoloader status. |
| `fnc_webAction` |  | The ammunition handler's actions in HTML (sphammohandler_fnc_webView), as the classic dialog's; the form holds the values the page sent (tablet_fnc_webReceive): ahAmmo        the round to prepare (its fuze modes follow it) ahCharge d    one charge up (1) or down (-1) ahFuze        another fuze mode ahApply       the settings the loader works with (sphammohandler_fnc_applyLoaderSettings) ahLoad        load / unload, a mortar prepare / fire (sphammohandler_fnc_loadGun) ahStow        a mortar: stow the prepared round ahFdcOrders   fill in the FDC's round, charge, fuze, count and GPS target |
| `fnc_webView` |  | The ammunition handler in HTML (a panel of the tablet's web page, tablet_fnc_webState), as the classic dialog: the rounds the vehicle carries, the round to prepare with its charge, fuze and guidance, the count (not for a mortar), FDC ORDERS, APPLY SETTINGS and LOAD / UNLOAD (a mortar: PREPARE / FIRE, STOW), and the applied settings with the loader status. |
