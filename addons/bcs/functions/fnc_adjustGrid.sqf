#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Adjusts a position along and perpendicular to a given observer-target (OT)
 * direction, and vertically, producing an artillery grid-correction style
 * adjustment (add/drop, left/right, up/down).
 *
 * Arguments:
 * 0: Origin position to adjust from <ARRAY> (Position ASL)
 * 1: Observer-target direction <NUMBER> (mils)
 * 2: Add/drop distance along the OT line <NUMBER> (metres, positive = add/away)
 * 3: Left/right distance perpendicular to the OT line <NUMBER> (metres, positive = right)
 * 4: Up/down elevation adjustment <NUMBER> (metres)
 *
 * Return Value:
 * Adjusted position <ARRAY> (Position ASL)
 *
 * Example:
 * [_origin, _ot, _ad, _lr, _ud] call itc_land_bcs_fnc_adjustGrid
 *
 * Public: No
 */

params ["_origin", "_ot", "_ad", "_lr", "_ud"];
//player sideChat str _this;
_otDeg = _ot / 6400 * 360; //ot dir in mils
_target = _origin getPos [_ad, _otDeg]; //apply add/drop
_target = _target getPos [_lr, _otDeg + 90]; //apply left/right by simply adding the distance 90 degrees offset from the OT
_target = _target vectorAdd [0,0,_ud]; //finally apply up/down
_target
