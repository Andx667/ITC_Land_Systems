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
    // UAV-type vehicles (VLS, Hammer 2, Defender 2) only work with their UAV AI inside, players connect with a UAV terminal
    if (_crewed || {getNumber (configOf _vehicle >> "isUav") == 1}) then {createVehicleCrew _vehicle};
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
    private _howitzer = [_class, [_posX, 7040, 0], 0] call itc_test_fnc_spawn;
    // no vehicle carries these rounds by default: Falat (two laser codes) and the Extra cargo shell
    if (_class == "itc_land_b_SPH_Sholef2") then {
        {_howitzer addMagazineTurret [_x, [0], 3]} forEach ["itc_land_g155falat", "itc_land_g155ext"];
    };
} forEach [
    ["itc_land_b_SPH_Sholef2", 6060],
    ["itc_land_o_sph_sochor2", 6100],
    ["itc_land_NGS01_hammer2", 6140],
    ["itc_land_NGS01_hammer2_mod1", 6180],
    ["itc_land_b_mlrs_seara2", 6220],
    ["itc_land_i_mlrs_zamak", 6260]
];
["itc_test_artillery", [6160, 7040, 0], "Artillery park (3, 4, 5, 15)"] call itc_test_fnc_marker;

// --- station: packing (packed UAVs are in the player loadout; empty Strider for the commander optic) ---

["itc_land_I_StriderRV", [6176, 7124, 0], 0] call itc_test_fnc_spawn;
["itc_test_packing", [6173, 7113, 0], "Packing (8), empty Strider"] call itc_test_fnc_marker;

// --- station: VLS (all UAV-crewed; the right one is the AI-shot launcher) ------------------------------------------------------------------------

["itc_land_b_vls2", [6060, 6960, 0], 270] call itc_test_fnc_spawn;
["itc_land_b_vls2_slam", [6100, 6960, 0], 270] call itc_test_fnc_spawn;
itc_test_vlsAi = ["itc_land_b_vls2_slam", [6140, 6960, 0], 270, true] call itc_test_fnc_spawn;
["itc_test_vls", [6100, 6960, 0], "VLS (6); UAV terminal, right one for the AI shot"] call itc_test_fnc_marker;

// --- station: COBRA (two radars facing the enemy battery, siren near the impact area) ---

["itc_land_COBRA01", [6080, 7400, 0], 270, true] call itc_test_fnc_spawn;
["itc_land_COBRA01", [6120, 7400, 0], 270, true] call itc_test_fnc_spawn;
["ITC_Land_Loudspeakers", [5600, 7650, 0], 0] call itc_test_fnc_spawn;
["itc_test_cobra", [6100, 7400, 0], "COBRA x2 (9)"] call itc_test_fnc_marker;
["itc_test_cobraImpact", [5600, 7700, 0], "COBRA barrage impact + siren", "mil_destroy"] call itc_test_fnc_marker;

// --- station: CIWS -------------------------------------------------------------------------

// logs decoy and CIWS sensor state to the RPT ([ITC CIWS])
missionNamespace setVariable ["itc_land_ciws_debug", true];
itc_test_ciwsUnits = [
    ["itc_land_cram_praetorian2", [6600, 7200, 0], 270, true] call itc_test_fnc_spawn,
    ["itc_land_ciws_centurion2", [6640, 7200, 0], 270, true] call itc_test_fnc_spawn
];
// RPT: how close a CIWS round came to the nearest shell decoy, split into along its flight path
// (ahead = led too much, behind = led too little) and to the side
itc_test_fnc_trackRound = {
    params ["_round"];
    private _decoys = vehicles select {(typeOf _x) find "itc_land_shell_" == 0};
    if (_decoys isEqualTo []) exitWith {};
    private _decoy = [_decoys, _round] call BIS_fnc_nearestPosition;
    [{
        params ["_args", "_pfh"];
        _args params ["_round", "_decoy", "_prev", "_best", "_bestRel", "_start"];
        private _done = !alive _round || {!alive _decoy} || {time - _start > 4};
        if (!_done) then {
            // closest point to the decoy on the segment the round travelled this frame
            private _cur = getPosASL _round;
            private _seg = _cur vectorDiff _prev;
            private _len2 = _seg vectorDotProduct _seg;
            private _t = if (_len2 > 0) then {((((getPosASL _decoy) vectorDiff _prev) vectorDotProduct _seg) / _len2) max 0 min 1} else {0};
            private _rel = (_prev vectorAdd (_seg vectorMultiply _t)) vectorDiff (getPosASL _decoy);
            if (vectorMagnitude _rel < _best) then {
                _args set [3, vectorMagnitude _rel];
                _args set [4, [_rel, velocity _decoy, round (_decoy distance (_args # 6))]];
            };
            _args set [2, _cur];
        } else {
            [_pfh] call CBA_fnc_removePerFrameHandler;
            if (_bestRel isNotEqualTo []) then {
                _bestRel params ["_rel", "_vel", "_range"];
                private _along = _rel vectorDotProduct (vectorNormalized _vel);
                diag_log format ["[ITC CIWS] round miss %1 m: %2 m %3, %4 m to the side (decoy %5 m from the gun)", _best toFixed 1, (abs _along) toFixed 1, ["behind", "ahead"] select (_along > 0), (sqrt ((_best ^ 2 - _along ^ 2) max 0)) toFixed 1, _range];
            };
        };
    }, 0, [_round, _decoy, getPosASL _round, 1e10, [], time, itc_test_ciwsUnits # 0]] call CBA_fnc_addPerFrameHandler;
};

// RPT: every hit on a shell decoy (if rounds hit but the decoy survives, its armour is the problem)
["itc_land_shell_b", "Hit", {
    params ["_decoy", "_source", "_damage"];
    diag_log format ["[ITC CIWS] decoy hit by %1, damage +%2 (total %3), altATL %4 m", typeOf _source, _damage toFixed 2, (damage _decoy) toFixed 2, round (getPosATL _decoy # 2)];
}] call CBA_fnc_addClassEventHandler;
["itc_land_shell_b", "Killed", {
    params ["_decoy", "_killer"];
    diag_log format ["[ITC CIWS] decoy destroyed by %1, altATL %2 m", typeOf _killer, round (getPosATL _decoy # 2)];
}] call CBA_fnc_addClassEventHandler;

// RPT: each burst a CIWS starts (nearest shell decoy, its altitude, rounds left) and its running shot count
{
    _x addEventHandler ["Fired", {
        params ["_unit", "_weapon", "", "", "", "", "_projectile"];
        private _shots = (_unit getVariable ["itc_test_shots", 0]) + 1;
        _unit setVariable ["itc_test_shots", _shots];
        if (typeOf _unit == "itc_land_cram_praetorian2" && {_shots % 20 == 0}) then {[_projectile] call itc_test_fnc_trackRound};
        // a new burst: more than 2 s since the last round
        if (time - (_unit getVariable ["itc_test_lastShot", -10]) > 2) then {
            private _decoys = vehicles select {(typeOf _x) find "itc_land_shell_" == 0};
            private _nearest = [_decoys, _unit] call BIS_fnc_nearestPosition;
            private _where = if (_nearest isEqualType objNull && {!isNull _nearest}) then {
                format ["nearest decoy %1 m, altATL %2 m", round (_unit distance _nearest), round (getPosATL _nearest # 2)]
            } else {"no decoy alive"};
            diag_log format ["[ITC CIWS] %1 starts a burst: %2, rounds left %3 (shot %4)", typeOf _unit, _where, _unit ammo _weapon, _shots];
        };
        _unit setVariable ["itc_test_lastShot", time];
    }];
} forEach itc_test_ciwsUnits;
["itc_test_ciws", [6620, 7200, 0], "CIWS (10)"] call itc_test_fnc_marker;
["itc_test_ciwsImpact", [6620, 7400, 0], "CIWS barrage impact", "mil_destroy"] call itc_test_fnc_marker;

// --- enemy battery (fires the barrages for COBRA and CIWS) ---------------------------------

itc_test_battery = [];
{
    private _gun = ["O_MBT_02_arty_F", _x, 90, true] call itc_test_fnc_spawn;
    [_gun, false] call itc_test_fnc_pacify;
    itc_test_battery pushBack _gun;
} forEach [[2400, 7400, 0], [2400, 7460, 0]];
["itc_test_battery", [2400, 7430, 0], "Enemy battery", "o_art"] call itc_test_fnc_marker;

// --- station: SAM (two UAV-crewed Defenders: one fires on its own, one a player controls via UAV terminal) -------------------------

["itc_land_b_defender2", [6600, 6900, 0], 90, true] call itc_test_fnc_spawn;
private _playerSam = ["itc_land_b_defender2", [6640, 6900, 0], 90] call itc_test_fnc_spawn;
// holds fire so the player shot is the player's, not the UAV AI's
(group effectiveCommander _playerSam) setCombatMode "BLUE";
["itc_test_sam", [6620, 6900, 0], "SAM-35 (11); UAV terminal"] call itc_test_fnc_marker;

// --- station: APS (crewed tank without ammo, shooters spawn on demand) ---------------------

// logs every tracked rocket/missile and why each module did or did not fire to the RPT ([ITC APS])
missionNamespace setVariable ["itc_land_aps_debug", true, true];

itc_test_apsTank = ["B_MBT_01_cannon_F", [6400, 6700, 0], 180, true] call itc_test_fnc_spawn;
[itc_test_apsTank] call itc_test_fnc_pacify;
["itc_test_aps", [6400, 6700, 0], "APS tank (12)"] call itc_test_fnc_marker;
["itc_test_apsShooters", [6400, 6400, 0], "APS shooters", "o_inf"] call itc_test_fnc_marker;

// --- station: Spike (AI shooter post and a target APC) -------------------------------------

itc_test_spikeTarget = ["O_APC_Tracked_02_cannon_F", [6200, 6100, 0], 0, true] call itc_test_fnc_spawn;
[itc_test_spikeTarget] call itc_test_fnc_pacify;
["itc_test_spike", [6200, 6700, 0], "Spike post (13)"] call itc_test_fnc_marker;
["itc_test_spikeTarget", [6200, 6100, 0], "Spike target", "o_mech_inf"] call itc_test_fnc_marker;

// --- UAV apron: the bigger UAVs parked facing north, flown with the UAV terminal ----------
// (the MQ-4I is the laser-capable one for ROVER; nothing is in the take-off path)

["ITC_Land_B_UAV_MQ4i", [6240, 7180, 0], 0, true] call itc_test_fnc_spawn;
["ITC_Land_B_UAV_UCAVi", [6280, 7180, 0], 0, true] call itc_test_fnc_spawn;
["itc_test_rover", [6260, 7170, 0], "UAV apron: MQ-4I (ROVER), UCAVi"] call itc_test_fnc_marker;

// --- Zeus: one curator from mission start, more can be created mid-mission ----------------

itc_test_fnc_createCurator = {
    private _curator = (createGroup sideLogic) createUnit ["ModuleCurator_F", [0, 0, 0], [], 0, "NONE"];
    // all loaded addons: the mission itself only declares A3_Characters_F, so "active addons" misses ITC
    _curator setVariable ["Addons", 3, true];
    // no owner: assignment goes through the control board (an empty owner errors in singleplayer)
    _curator setVariable ["owner", "objNull"];
    _curator setVariable ["showNotification", false];
    // a scripted module never runs its init (addons, placement and attribute handlers) unless activated
    _curator setVariable ["bis_fnc_initModules_disableAutoActivation", false, true];
    _curator setVariable ["bis_fnc_initModules_activate", true];
    _curator addCuratorEditableObjects [vehicles + allUnits, true];
    _curator
};
itc_test_startCurator = call itc_test_fnc_createCurator;

// --- scenario events (raised from the control board) ---------------------------------------

// A/B test of CIWS accuracy: radar forced on (mod default at init) or left to the AI
["itc_test_ciwsRadar", {
    params ["_mode", "_caller"];
    {_x setVehicleRadar _mode} forEach itc_test_ciwsUnits;
    private _text = ["CIWS radar: automatic (AI decides)", "CIWS radar: forced on"] select (_mode == 1);
    diag_log format ["[ITC CIWS] TEST %1", _text];
    ["itc_test_notify", [_text], _caller] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

["itc_test_barrage", {
    params ["_targetPos", "_caller"];
    diag_log format ["[ITC CIWS] TEST barrage at %1, %2 m from the CIWS, radar mode %3", _targetPos, round ((itc_test_ciwsUnits # 0) distance2D _targetPos), itc_test_ciwsUnits apply {isVehicleRadarOn _x}];
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

["itc_test_ciwsDebug", {
    params ["_caller"];
    private _lines = [];
    {
        private _unit = _x;
        private _targets = getSensorTargets _unit;
        _lines pushBack format ["%1: radar on %2, %3 sensor target(s)", typeOf _unit, isVehicleRadarOn _unit, count _targets];
        {
            _x params ["_object", "_type", "_relation"];
            _lines pushBack format ["  %1 %2 %3 (%4 m)", typeOf _object, _type, _relation, round (_object distance _unit)];
        } forEach (_targets select [0, 4]);
    } forEach itc_test_ciwsUnits;
    private _decoys = vehicles select {(typeOf _x) find "itc_land_shell_" == 0};
    _lines pushBack format ["Decoys alive: %1", count _decoys];
    {
        _lines pushBack format ["  %1 side %2 alt %3 m speed %4 m/s crew %5", typeOf _x, side group driver _x, round (getPosATL _x select 2), round speed _x, count crew _x];
    } forEach (_decoys select [0, 4]);
    ["itc_test_notify", [_lines joinString "\n"], _caller] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;

["itc_test_zeus", {
    params ["_new", "_caller"];
    private _curator = if (_new) then {call itc_test_fnc_createCurator} else {itc_test_startCurator};
    unassignCurator _curator;
    _caller assignCurator _curator;
    private _text = ["Mission-start Zeus assigned", "New Zeus created mid-mission and assigned"] select _new;
    ["itc_test_notify", [_text], _caller] call CBA_fnc_targetEvent;
}] call CBA_fnc_addEventHandler;
