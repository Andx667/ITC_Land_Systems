/*
 * Test range for the in-game checklist (GitHub issue #3), player side:
 * loadout, control board actions (teleports, scenarios, diagnostics) and briefing.
 * The scenarios run on the server (initServer.sqf).
 */
params ["_player"];

itc_test_fnc_loadout = {
    player addBackpack "B_Kitbag_mcamo";
    player linkItem "B_UavTerminal";
    {player addItem _x} forEach ["itc_land_tablet_fdc", "itc_land_tablet_spg", "itc_land_tablet_rover", "ITC_Land_B_AR2i_Packed", "ITC_Land_B_RemoteGLTD_Packed", "ITC_Land_B_AL6_Packed"];
};
call itc_test_fnc_loadout;
_player addEventHandler ["Respawn", {call itc_test_fnc_loadout}];

["itc_test_notify", {
    params ["_text"];
    hint _text;
}] call CBA_fnc_addEventHandler;

// --- briefing ------------------------------------------------------------------------------

player createDiaryRecord ["Diary", ["Test stations", "
Numbers are the sections of the checklist in GitHub issue #3. Use the control board next to the arsenal for teleports, scenarios and diagnostics.<br/><br/>
<marker name='itc_test_artillery'>Artillery park</marker>: Sholef 2, Sochor 2, Hammer 2 (mod 0/1), Seara 2, Zamak MRLi. SPH loader (5, 15), gunner sights (15), mounted tablets (11), Falat (12). Two players: one gunner, one driver/commander.<br/>
<marker name='itc_test_packing'>Packing</marker>: an empty Strider for the commander optic. Packed AR-2i, Remote GLTD and AL-6 are in your inventory: unpack, control, pack again (10).<br/>
<marker name='itc_test_vls'>VLS</marker>: two empty launchers for players, one with an AI gunner for the unguided AI shot (9).<br/>
<marker name='itc_test_cobra'>COBRA</marker>: two radars facing the enemy battery, siren at the impact area (3). Use 'Barrage on COBRA impact area'.<br/>
<marker name='itc_test_ciws'>CIWS</marker>: Praetorian 2 and Centurion 2 (8). Use 'Barrage near CIWS', then 'Show AI units and groups'. Zeus: take the mission-start Zeus or create a new one mid-mission, place a radar vehicle.<br/>
<marker name='itc_test_sam'>SAM-35</marker>: AI-crewed and empty Defender 2 (7). Use 'Air target'.<br/>
<marker name='itc_test_aps'>APS</marker>: crewed tank without ammo (4). Use 'APS attack' and/or shoot it with launchers from the arsenal from two machines.<br/>
<marker name='itc_test_spike'>Spike</marker>: player Spike from the arsenal or 'AI Spike shot' against the target APC (6).<br/>
<marker name='itc_test_rover'>ROVER</marker>: MQ-4I loitering over the target area. Connect with the UAV terminal, lase, open the ROVER tablet (16).<br/>
Tablets (FDC, SPG, ROVER) and a UAV terminal are in your inventory (11, 15, 16).<br/><br/>
Diagnostics: 'Show per-frame handler count' should not keep growing after entering and leaving gunner seats (15). Settings: Escape, Options, Addon Options, ITC Land Systems (1).
"]];

// --- control board -------------------------------------------------------------------------

[{!isNil "itc_test_board"}, {
    private _add = {
        params ["_title", "_code", ["_args", []]];
        itc_test_board addAction [_title, _code, _args, 1.5, false, true, "", "true", 5];
    };
    private _teleport = {
        params ["", "", "", "_pos"];
        player setPosATL _pos;
    };
    // the caller is added when the action is used, so it is the current unit after a respawn
    private _server = {
        params ["", "_caller", "", "_args"];
        _args params ["_event", "_params"];
        [_event, _params + [_caller]] call CBA_fnc_serverEvent;
    };

    {
        _x params ["_name", "_pos"];
        [format ["<t color='#9fd3ff'>Teleport: %1</t>", _name], _teleport, _pos] call _add;
    } forEach [
        ["Artillery park", [6160, 7025, 0]],
        ["Packing", [6165, 7104, 0]],
        ["VLS", [6100, 6948, 0]],
        ["COBRA", [6100, 7388, 0]],
        ["CIWS", [6620, 7188, 0]],
        ["SAM-35", [6620, 6888, 0]],
        ["APS tank", [6400, 6720, 0]],
        ["Spike post", [6200, 6712, 0]]
    ];

    {
        _x params ["_title", "_event", "_params"];
        [format ["<t color='#ffb84d'>%1</t>", _title], _server, [_event, _params]] call _add;
    } forEach [
        ["Barrage on COBRA impact area", "itc_test_barrage", [[5600, 7700, 0]]],
        ["Barrage near CIWS", "itc_test_barrage", [[6620, 7600, 0]]],
        ["APS attack (2 AI AT soldiers)", "itc_test_apsAttack", []],
        ["AI Spike shot", "itc_test_aiSpike", []],
        ["Air target for the SAM-35", "itc_test_airTarget", []],
        ["AI VLS shot without target", "itc_test_aiVls", []],
        ["Take mission-start Zeus", "itc_test_zeus", [false]],
        ["Create new Zeus (mid-mission curator)", "itc_test_zeus", [true]]
    ];

    ["<t color='#a0ffa0'>Show AI units and groups</t>", {
        hint format ["Groups: %1\nUnits: %2\nVehicles: %3", count allGroups, count allUnits, count vehicles];
    }] call _add;
    ["<t color='#a0ffa0'>Show per-frame handler count</t>", {
        hint format ["CBA per-frame handlers on this machine: %1", count (missionNamespace getVariable ["cba_common_perFrameHandlerArray", []])];
    }] call _add;
}] call CBA_fnc_waitUntilAndExecute;
