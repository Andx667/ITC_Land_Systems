#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Fired event handler for ITC Howitzers firing Mof35Mod3-fuzed shells. Builds a
 * guidance info array (laser codes, target grid, target altitude) from the
 * firing vehicle's variables, then, once the time fuze elapses, deletes the
 * projectile (if it still exists) and spawns its configured submunitions
 * (e.g. laser-guided Falat rounds) with that guidance info.
 *
 * Arguments:
 * 0: Vehicle that fired the weapon <OBJECT>
 * 1: Ammo/simulation class of the fired round <STRING>
 * 2: Magazine class fired <STRING>
 * 3: Fired projectile <OBJECT>
 * 4: Gunner occupying the firing turret; function exits if not local <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "", "", "", _ammo, _magazine, _projectile, _gunner] call itc_land_veh_weapons_fnc_firedMof35Mod3
 *
 * Public: No
 */

params ["_vehicle", "", "", "", "_ammo", "_magazine", "_projectile", "_gunner"];
if (!local _gunner) exitWith {};

private _fuzeValue = _vehicle getVariable ["itc_land_fuzeValues",0];
private _guidanceInfo = [
    [
        _vehicle getVariable ["itc_land_guidance_laserCode",1111],
        _vehicle getVariable ["itc_land_guidance_laserCode_2",1112]
    ],
    _vehicle getVariable ["itc_land_guidance_targetGrid","00000000"],
    _vehicle getVariable ["itc_land_guidance_targetAlt",0]
];

[{
    params ["_projectile", "_magazine", "_guidanceInfo"];
    if (!alive _projectile) exitWith {};

    private _subMunitionScript = configFile >> "CfgMagazines" >> _magazine >> "itc_land_submunitionScript";
    private _subMunitionCount = getNumber (configFile >> "CfgMagazines" >> _magazine >> "itc_land_submunitionCount");
    (_projectile call BIS_fnc_getPitchBank) params ["_pitch", "_bank"];
    if (isText _subMunitionScript) then {
        for "_i" from 1 to _subMunitionCount step 1 do {
            [_i, getPosASL _projectile, velocity _projectile, _pitch, _bank, _guidanceInfo] call (missionNamespace getVariable [getText _subMunitionScript, {}]);
        };
    };

    deleteVehicle _projectile;
    }, [_projectile, _magazine, _guidanceInfo], _fuzeValue] call CBA_fnc_waitAndExecute;
