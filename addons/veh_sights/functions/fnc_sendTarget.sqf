#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * "Send target to FDC" keybind: from the ITC observer optics (UAV gunner, GLTD, Strider
 * commander) sends the target to every friendly FDC over the datalink, like a digital call for
 * fire: the lased spot while the platform's laser is on, else the point in the centre of the
 * view. It arrives in the FDCs' BCS Location Stores (see the BCS app's init.sqf). The observer
 * connects to the datalink when the optics open.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * True if the key was handled (the optics are open) <BOOL>
 *
 * Example:
 * [] call itc_land_veh_sights_fnc_sendTarget
 *
 * Public: No
 */

// the ITC observer optics showing right now (runOptics hides its group outside the optics view)
private _optics = ["ITC_Land_RscOptics_UAV_gunner", "ITC_Land_RscOptics_GLTD_gunner", "ITC_Land_RscOptics_strider_commander"] findIf {
    ctrlShown ((uiNamespace getVariable [_x, displayNull]) displayCtrl 75001)
};
if (_optics == -1) exitWith {false};

if !([ACE_player] call EFUNC(datalink,connectPlayer)) exitWith {
    [LLSTRING(SendTargetConnecting)] call ace_common_fnc_displayTextStructured;
    true
};

private _platform = if (cameraOn in allUnitsUAV) then {getConnectedUAV ACE_player} else {vehicle ACE_player};
private _laserSpot = laserTarget _platform;
private _targetPos = if (isLaserOn _platform && {!isNull _laserSpot}) then {getPosASL _laserSpot} else {AGLToASL screenToWorld [0.5, 0.5]};

["0000", ACE_player getVariable [QEGVAR(datalink,id), ""], "observer", "target", [name ACE_player, side group ACE_player, _targetPos]] call EFUNC(datalink,transmit);

playSound "TacticalPing3";
[format [LLSTRING(SendTargetSent), [_targetPos] call EFUNC(common,posToGrid), round (_targetPos # 2)]] call ace_common_fnc_displayTextStructured;
true
