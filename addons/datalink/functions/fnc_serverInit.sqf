#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the datalink server: creates the node registry hash and registers the CBA event handlers for client connect, client disconnect, and client transmit events. Server-side only.
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

if(!isServer) exitWith {}; //end code if not server

//create the address list hash, this will consist of IDGR: machine(server or client)
itc_land_datalink_nodes = [] call CBA_fnc_hashCreate;

//add the eventhandlers for connecting and disconnecting clients
itc_land_datalink_eh_clientConnect = [QGVAR(clientConnect), FUNC(onClientConnect)] call CBA_fnc_addEventHandler;
itc_land_datalink_eh_clientDisconnect = [QGVAR(clientDisconnect), FUNC(onClientDisconnect)] call CBA_fnc_addEventHandler;

//add eventhandlers for handling transmissions
itc_land_datalink_eh_clientTX = [QGVAR(clientTX), FUNC(onClientTX)] call CBA_fnc_addEventHandler;
