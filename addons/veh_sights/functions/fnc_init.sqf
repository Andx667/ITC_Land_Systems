#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Registers the local event handlers for each vehicle gunner-sight display's onLoad
 * function, and adds a CBA player event handler that re-fires a vehicle's stored sight
 * event when the player re-enters it, restoring that display's gunner-sight HUD.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_veh_sights_fnc_init
 *
 * Public: No
 */

["itc_land_onLoad_RscGunnerSightSPH", FUNC(onLoad_RscGunnerSightSPH)] call CBA_fnc_addEventHandler;
["itc_land_onLoad_RscGunnerSightBasic", FUNC(onLoad_RscGunnerSightBasic)] call CBA_fnc_addEventHandler;
["itc_land_onLoad_RscAltGunnerSightSPH", FUNC(onLoad_RscAltGunnerSightSPH)] call CBA_fnc_addEventHandler;
["itc_land_onLoad_RscGunnerSightMLRS", FUNC(onLoad_RscGunnerSightMLRS)] call CBA_fnc_addEventHandler;
["itc_land_onLoad_RscGunnerSightZamakMRLi", FUNC(onLoad_RscGunnerSightZamakMRLi)] call CBA_fnc_addEventHandler;
["itc_land_onLoad_RscIGS_SPH", FUNC(onLoad_RscIGS_SPH)] call CBA_fnc_addEventHandler;
["itc_land_onLoad_RscOptics_UAV_gunner", FUNC(onLoad_RscOptics_UAV_gunner)] call CBA_fnc_addEventHandler;
["itc_land_onLoad_RscOptics_GLTD_gunner", FUNC(onLoad_RscOptics_GLTD_gunner)] call CBA_fnc_addEventHandler;
["itc_land_onLoad_RscOptics_strider_commander", FUNC(onLoad_RscOptics_strider_commander)] call CBA_fnc_addEventHandler;

["vehicle", {
    params ["_player", "_newVehicle"];
    if (count (currentWeapon _player) > 0) exitWith {};
    if (isNull _newVehicle) exitWith {};
    private _sightEvent = _newVehicle getVariable "ITC_Land_SightEvent";
    if (isNil "_sightEvent") exitWith {};

    //Restore sight display
    [_sightEvent, []] call CBA_fnc_localEvent;
}, true] call CBA_fnc_addPlayerEventHandler;
