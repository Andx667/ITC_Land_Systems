#include "..\script_component.hpp"

params ["", "", "", "", "_ammo", "", "_projectile", "_gunner"];
if (!local _gunner) exitWith {};
_this call FUNC(guide);
_this call BIS_fnc_effectFiredCruiseMissile;
