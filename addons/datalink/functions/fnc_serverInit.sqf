#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the datalink server: creates the node registry hashmap, registers the CBA event handlers for client connect, client disconnect, and client transmit events, and removes registry entries whose object is deleted or whose connecting player disconnects. Server-side only.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_datalink_fnc_serverInit
 *
 * Public: No
 */

if (!isServer) exitWith {}; //end code if not server

//create the address list, a hashmap of ID: [object, machine ID that connected it]
itc_land_datalink_nodes = createHashMap;

//drop entries for deleted objects and for machines that left, so transmissions don't go to dead targets
addMissionEventHandler ["EntityDeleted", {
    params ["_entity"];
    [0, _entity] call FUNC(removeNodes);
}];
addMissionEventHandler ["PlayerDisconnected", {
    params ["", "", "", "", "_owner"];
    [1, _owner] call FUNC(removeNodes);
}];

//add the eventhandlers for connecting and disconnecting clients
itc_land_datalink_eh_clientConnect = [QGVAR(clientConnect), FUNC(onClientConnect)] call CBA_fnc_addEventHandler;
itc_land_datalink_eh_clientDisconnect = [QGVAR(clientDisconnect), FUNC(onClientDisconnect)] call CBA_fnc_addEventHandler;

//add eventhandlers for handling transmissions
itc_land_datalink_eh_clientTX = [QGVAR(clientTX), FUNC(onClientTX)] call CBA_fnc_addEventHandler;
