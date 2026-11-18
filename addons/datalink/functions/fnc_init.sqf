#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes shared datalink settings from config (allowed ID characters and ID length)
 * and registers the clientRX event that delivers transmissions to local objects. Runs on both clients and the server.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_datalink_fnc_init
 *
 * Public: No
 */

//Load the list of characters allowed in IDs
GVAR(allowedIDCharacters) = (configFile >> "itc_land_datalink" >> "allowedIDCharacters") call BIS_fnc_getCfgData;
//Load the list of characters allowed in IDs
GVAR(IDLength) = getNumber (configFile >> "itc_land_datalink" >> "IDLength");

[QGVAR(clientRX), FUNC(onClientRX)] call CBA_fnc_addEventHandler;
