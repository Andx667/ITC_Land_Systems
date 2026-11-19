#include "..\script_component.hpp"

/*
 * Author: Andx
 * Registers a system for the debug overlay (fnc_debugDraw, setting itc_land_common_debug). Each system adds lines to the
 * label of the objects it knows and can draw its own lines and markers. Call it in preInit on every machine with an
 * interface; common keeps no knowledge of the systems, as they depend on common and not the other way round.
 *
 * Arguments:
 * 0: Id of the system, unique across the addons <STRING>
 * 1: Does the object have the system, called every frame with [object] for vehicles and units on foot near the
 *    camera; keep it cheap or cache the answer <CODE>
 * 2: Lines of the object's label, called with [object]; each line is a text or [text, color] <CODE>
 * 3: Extra drawing (drawLine3D, fnc_debugText), called every frame with [objects near the camera] (default: {}) <CODE>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["itc_land_cobra", {_this # 0 in itc_land_cobra_vehicles}, {["COBRA"]}] call itc_land_common_fnc_registerDebug
 *
 * Public: No
 */

params [["_id", "", [""]], ["_hasSystem", {false}, [{}]], ["_getLines", {[]}, [{}]], ["_draw", {}, [{}]]];

if (_id isEqualTo "") exitWith {};

GVAR(debugProviders) set [_id, [_hasSystem, _getLines, _draw]];
