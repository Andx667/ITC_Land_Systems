#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Sets the target of the vehicle's GPS guided rounds: the position they fly to
 * (itc_land_guidance_targetPos), and the grid and altitude it was entered as, so the ammunition
 * handler and the FCI can show them again.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Target grid <STRING>
 * 2: Target altitude (m ASL) <NUMBER>
 *
 * Return Value:
 * Target position <ARRAY>
 *
 * Example:
 * [_vehicle, "0123456789", 120] call itc_land_common_fnc_setGpsTarget
 *
 * Public: No
 */

params ["_vehicle", "_grid", "_alt"];

private _targetPos = [_grid, _alt] call FUNC(gridToPos);
_vehicle setVariable ["itc_land_guidance_targetGrid", _grid, true];
_vehicle setVariable ["itc_land_guidance_targetAlt", _alt, true];
_vehicle setVariable ["itc_land_guidance_targetPos", _targetPos, true];
_targetPos
