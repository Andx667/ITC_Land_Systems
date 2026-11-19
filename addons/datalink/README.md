# Datalink

`itc_land_datalink`: ID registry and messages between objects, for systems that exchange data.

## Dependencies

- ITC: `itc_land_common`

## Files

- `CfgMisc.hpp`

## CBA events

Internal events this addon handles (raised with `CBA_fnc_*Event`):

- `itc_land_datalink_clientRX` (`functions/fnc_init.sqf`)
- `itc_land_datalink_clientConnect` (`functions/fnc_serverInit.sqf`)
- `itc_land_datalink_clientDisconnect` (`functions/fnc_serverInit.sqf`)
- `itc_land_datalink_clientTX` (`functions/fnc_serverInit.sqf`)

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_connect` |  | Connects an object to the datalink server, requesting a new ID for the given system (or validating an explicitly supplied one), and optionally auto-storing the assigned ID on the target once the server responds. |
| `fnc_connectPlayer` |  | Connects a player's unit to the datalink with an automatic ID (stored as itc_land_datalink_id), once per unit: later calls for the same unit do nothing, and after a respawn the new unit connects again. |
| `fnc_debugLines` |  | Lines of the debug overlay for an object on the datalink: its ID and group, and those of its crew. |
| `fnc_disconnect` |  | Disconnects an object from the datalink server, removing the given ID (or, if no ID is given, every ID currently registered to the object) from the server's node registry. |
| `fnc_findAvailableID` |  | Finds and returns the next unused datalink ID within a given group by generating candidate IDs from the allowed ID character set and checking them against the current node registry. |
| `fnc_findIDTargets` |  | Finds all targets registered under a given datalink ID. |
| `fnc_init` |  | Initializes shared datalink settings from config (allowed ID characters and ID length) and registers the clientRX event that delivers transmissions to local objects. |
| `fnc_onClientConnect` |  | Server-side event handler for a client connection request. |
| `fnc_onClientDisconnect` |  | Server-side event handler for a client disconnection request. |
| `fnc_onClientRX` |  | Handles an incoming datalink transmission received by a non-player object, dispatching it to any handler functions the object has registered (via registerEvent) whose header and type match the transmission. |
| `fnc_onClientTX` |  | Server-side event handler that relays a transmission out to all targets currently registered under the destination ID, on the machine that connected each target. |
| `fnc_receiveIDRegistry` |  | Handles the response to an ID registration request; if the registration succeeded, stores the assigned datalink ID on the target object (public, as itc_land_datalink_id). |
| `fnc_registerEvent` |  | Registers an event handler function on an object, to be called when a datalink transmission matching the given header and type is received by that object. |
| `fnc_removeNodes` |  | Removes every node registry entry whose object (index 0) or connecting machine ID (index 1) matches the given value. |
| `fnc_serverInit` |  | Initializes the datalink server: creates the node registry hashmap, registers the CBA event handlers for client connect, client disconnect, and client transmit events, and removes registry entries whose object is deleted or whose connecting player disconnects. |
| `fnc_transmit` |  | Validates the given origin and destination datalink IDs and, if both are valid, broadcasts the transmission to the server via the itc_land_datalink_clientTX event for delivery to matching targets. |
| `fnc_unregisterEvent` |  | Unregisters a previously registered datalink event handler of the given type from an object. |
| `fnc_validateID` |  | Validates a datalink ID string against the configured ID length and allowed character set, and optionally rejects broadcast ("00") group/node combinations. |
