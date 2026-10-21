/*
 * Test range for the in-game checklist (GitHub issue #3).
 * Builds every test station and handles the scenario events the control board raises
 * (see initPlayerLocal.sqf). Station positions are on the VR map around the spawn.
 */

// --- helpers ---------------------------------------------------------------------------

itc_test_fnc_marker = {
    params ["_name", "_pos", "_text", ["_type", "mil_flag"]];
    private _marker = createMarker [_name, _pos];
    _marker setMarkerTypeLocal _type;
    _marker setMarkerText _text;
};

itc_test_fnc_spawn = {
    params ["_class", "_pos", ["_dir", 0], ["_crewed", false], ["_special", "NONE"]];
    private _vehicle = createVehicle [_class, _pos, [], 0, _special];
    _vehicle setDir _dir;
    if (_special != "FLY") then {_vehicle setPosATL _pos};
    if (_crewed) then {createVehicleCrew _vehicle};
    _vehicle
};

// Crew that must not move or pick its own targets (targets, test dummies)
itc_test_fnc_pacify = {
    params ["_vehicle", ["_removeAmmo", true]];
    if (_removeAmmo) then {_vehicle setVehicleAmmo 0};
    {
        _x disableAI "MOVE";
        _x disableAI "AUTOTARGET";
        _x disableAI "TARGET";
    } forEach crew _vehicle;
};

// --- spawn, respawn, arsenal, control board ---------------------------------------------

["respawn_west", [6144, 7112, 0], "Spawn / respawn", "respawn_inf"] call itc_test_fnc_marker;

private _arsenal = ["B_supplyCrate_F", [6152, 7116, 0], 0] call itc_test_fnc_spawn;
clearItemCargoGlobal _arsenal;
clearMagazineCargoGlobal _arsenal;
clearWeaponCargoGlobal _arsenal;
clearBackpackCargoGlobal _arsenal;
[_arsenal, true, true] call ace_arsenal_fnc_initBox;

itc_test_board = ["Land_MapBoard_01_Wall_F", [6138, 7118, 0], 0] call itc_test_fnc_spawn;
publicVariable "itc_test_board";

// --- station: artillery park (SPH loader, sights, mounted tablets, fuzes, Falat) --------

{
    _x params ["_class", "_posX"];
    [_class, [_posX, 7040, 0], 0] call itc_test_fnc_spawn;
} forEach [
    ["itc_land_b_SPH_Sholef2", 6060],
    ["itc_land_o_sph_sochor2", 6100],
    ["itc_land_NGS01_hammer2", 6140],
    ["itc_land_NGS01_hammer2_mod1", 6180],
    ["itc_land_b_mlrs_seara2", 6220],
    ["itc_land_i_mlrs_zamak", 6260]
];
["itc_test_artillery", [6160, 7040, 0], "Artillery park (5, 11, 12, 15)"] call itc_test_fnc_marker;

// --- station: packing (packed UAVs are in the player loadout; empty Strider for the commander optic) ---

["itc_land_I_StriderRV", [6176, 7124, 0], 0] call itc_test_fnc_spawn;
["itc_test_packing", [6173, 7113, 0], "Packing (10), empty Strider"] call itc_test_fnc_marker;

// --- station: VLS ------------------------------------------------------------------------

["itc_land_b_vls2", [6060, 6960, 0], 270] call itc_test_fnc_spawn;
["itc_land_b_vls2_slam", [6100, 6960, 0], 270] call itc_test_fnc_spawn;
itc_test_vlsAi = ["itc_land_b_vls2_slam", [6140, 6960, 0], 270, true] call itc_test_fnc_spawn;
["itc_test_vls", [6100, 6960, 0], "VLS (9); right launcher has an AI gunner"] call itc_test_fnc_marker;

// --- station: COBRA (two radars facing the enemy battery, siren near the impact area) ---

["itc_land_COBRA01", [6080, 7400, 0], 270, true] call itc_test_fnc_spawn;
["itc_land_COBRA01", [6120, 7400, 0], 270, true] call itc_test_fnc_spawn;
["ITC_Land_Loudspeakers", [5600, 7650, 0], 0] call itc_test_fnc_spawn;
["itc_test_cobra", [6100, 7400, 0], "COBRA x2 (3)"] call itc_test_fnc_marker;
["itc_test_cobraImpact", [5600, 7700, 0], "COBRA barrage impact + siren", "mil_destroy"] call itc_test_fnc_marker;

// --- station: CIWS -------------------------------------------------------------------------

["itc_land_cram_praetorian2", [6600, 7200, 0], 270, true] call itc_test_fnc_spawn;
["itc_land_ciws_centurion2", [6640, 7200, 0], 270, true] call itc_test_fnc_spawn;
["itc_test_ciws", [6620, 7200, 0], "CIWS (8)"] call itc_test_fnc_marker;
["itc_test_ciwsImpact", [6620, 7600, 0], "CIWS barrage impact", "mil_destroy"] call itc_test_fnc_marker;

// --- enemy battery (fires the barrages for COBRA and CIWS) ---------------------------------

itc_test_battery = [];
{
    private _gun = ["O_MBT_02_arty_F", _x, 90, true] call itc_test_fnc_spawn;
    [_gun, false] call itc_test_fnc_pacify;
    itc_test_battery pushBack _gun;
} forEach [[2400, 7400, 0], [2400, 7460, 0]];
["itc_test_battery", [2400, 7430, 0], "Enemy battery", "o_art"] call itc_test_fnc_marker;

// --- station: SAM (one AI-crewed Defender, one empty for a player) -------------------------

["itc_land_b_defender2", [6600, 6900, 0], 90, true] call itc_test_fnc_spawn;
["itc_land_b_defender2", [6640, 6900, 0], 90] call itc_test_fnc_spawn;
["itc_test_sam", [6620, 6900, 0], "SAM-35 (7); left AI, right empty"] call itc_test_fnc_marker;

// --- station: APS (crewed tank without ammo, shooters spawn on demand) ---------------------

itc_test_apsTank = ["B_MBT_01_cannon_F", [6400, 6700, 0], 180, true] call itc_test_fnc_spawn;
[itc_test_apsTank] call itc_test_fnc_pacify;
["itc_test_aps", [6400, 6700, 0], "APS tank (4)"] call itc_test_fnc_marker;
["itc_test_apsShooters", [6400, 6400, 0], "APS shooters", "o_inf"] call itc_test_fnc_marker;

// --- station: Spike (AI shooter post and a target APC) -------------------------------------

itc_test_spikeTarget = ["O_APC_Tracked_02_cannon_F", [6200, 6100, 0], 0, true] call itc_test_fnc_spawn;
[itc_test_spikeTarget] call itc_test_fnc_pacify;
["itc_test_spike", [6200, 6700, 0], "Spike post (6)"] call itc_test_fnc_marker;
["itc_test_spikeTarget", [6200, 6100, 0], "Spike target", "o_mech_inf"] call itc_test_fnc_marker;

// --- ROVER: a laser-capable UAV loitering over the target area -----------------------------

private _roverUav = ["ITC_Land_B_UAV_MQ4i", [6200, 6600, 400], 180, true, "FLY"] call itc_test_fnc_spawn;
_roverUav flyInHeight 400;
private _loiter = (group driver _roverUav) addWaypoint [[6200, 6100, 0], 0];
_loiter setWaypointType "LOITER";
_loiter setWaypointLoiterRadius 600;
["itc_test_rover", [6200, 6350, 0], "ROVER UAV loiter (connect with the UAV terminal, lase)"] call itc_test_fnc_marker;

// --- Zeus: one curator from mission start, more can be created mid-mission ----------------

itc_test_fnc_createCurator = {
    private _curator = (createGroup sideLogic) createUnit ["ModuleCurator_F", [0, 0, 0], [], 0, "NONE"];
    _curator addCuratorAddons activatedAddons;
    _curator addCuratorEditableObjects [vehicles + allUnits, true];
    _curator
};
itc_test_startCurator = call itc_test_fnc_createCurator;

// --- scenario events (raised from the control board) ---------------------------------------

["itc_test_barrage", {
    params ["_targetPos", "_caller"];
    private _firing = 0;
    {
        _x setVehicleAmmo 1;
        // HE shells first; the COBRA tracks Sh_155mm_AMOS-based ammo
        private _ammo = getArtilleryAmmo [_x] param [0, ""];
        if (alive _x && _ammo != "" && {_targetPos inRangeOfArtillery [[_x], _ammo]}) then {
            _x doArtilleryFire [_targetPos, _ammo, 4];
            _firing = _firing + 1;
        };
    } forEach itc_test_battery;
    ["itc_test_notify", [format ["Barrage: %1 gun(s) firing 4 rounds each", _firing]], _caller] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

["itc_test_apsAttack", {
    params ["_caller"];
    private _group = createGroup east;
    {
        private _unit = _group createUnit ["O_Soldier_LAT_F", _x, [], 0, "NONE"];
        _unit disableAI "PATH";
        _unit setDir 0;
        _unit reveal [itc_test_apsTank, 4];
        _unit doTarget itc_test_apsTank;
        _unit doFire itc_test_apsTank;
    } forEach [[6380, 6400, 0], [6420, 6400, 0]];
    [{{deleteVehicle _x} forEach units _this; deleteGroup _this}, _group, 90] call CBA_fnc_waitAndExecute;
    ["itc_test_notify", ["APS attack: 2 AT soldiers for 90 s"], _caller] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

["itc_test_aiSpike", {
    params ["_caller"];
    private _unit = (createGroup west) createUnit ["B_Soldier_F", [6200, 6700, 0], [], 0, "NONE"];
    _unit addBackpack "B_Carryall_mcamo";
    _unit addMagazines ["itc_land_spikeLR_1rnd", 2];
    _unit addWeapon "itc_land_spikeLR";
    _unit selectWeapon "itc_land_spikeLR";
    _unit disableAI "PATH";
    _unit setDir 180;
    _unit reveal [itc_test_spikeTarget, 4];
    [{
        _this doTarget itc_test_spikeTarget;
        _this doFire itc_test_spikeTarget;
    }, _unit, 3] call CBA_fnc_waitAndExecute;
    [{deleteVehicle _this}, _unit, 90] call CBA_fnc_waitAndExecute;
    ["itc_test_notify", ["AI Spike gunner spawned, fires in a few seconds"], _caller] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

["itc_test_airTarget", {
    params ["_caller"];
    private _heli = createVehicle ["O_Heli_Light_02_unarmed_F", [9600, 6900, 300], [], 0, "FLY"];
    createVehicleCrew _heli;
    _heli flyInHeight 200;
    (group driver _heli) move [6600, 6900, 0];
    [{if (alive _this) then {deleteVehicleCrew _this; deleteVehicle _this}}, _heli, 240] call CBA_fnc_waitAndExecute;
    ["itc_test_notify", ["Air target inbound from the east"], _caller] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

["itc_test_aiVls", {
    params ["_caller"];
    // The AI gunner has no target set through the launch dialog: the round must fly unguided
    itc_test_vlsAi fireAtTarget [objNull, (itc_test_vlsAi weaponsTurret [0]) param [0, ""]];
    ["itc_test_notify", ["AI VLS launcher fired without a target"], _caller] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

["itc_test_zeus", {
    params ["_new", "_caller"];
    private _curator = if (_new) then {call itc_test_fnc_createCurator} else {itc_test_startCurator};
    unassignCurator _curator;
    _caller assignCurator _curator;
    private _text = ["Mission-start Zeus assigned", "New Zeus created mid-mission and assigned"] select _new;
    ["itc_test_notify", [_text], _caller] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;
