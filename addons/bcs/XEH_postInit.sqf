#include "script_component.hpp"

// every ITC gun joins the datalink (server), so an FDC can link it and send it fire data, and
// reports its first shot of the fire data back (every machine, where the gun is local)
["AllVehicles", "InitPost", {[_this select 0] call FUNC(gunInit)}, true, [], true] call CBA_fnc_addClassEventHandler;

// the crew (or UAV operator) of a gun that received fire data from the FDC
[QGVAR(fireDataReceived), {
    params ["_gun", "_mission", "_phase"];
    if (vehicle ACE_player != _gun && {!(ACE_player in UAVControl _gun)}) exitWith {};
    playSound "FD_Timer_F";
    [format [LLSTRING(FireDataReceived), _mission, _phase]] call ace_common_fnc_displayTextStructured;
}] call CBA_fnc_addEventHandler;
