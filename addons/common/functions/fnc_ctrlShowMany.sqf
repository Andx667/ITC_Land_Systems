#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Shows or hides several controls of the active dialog at once.
 *
 * Arguments:
 * 0: Control IDCs <ARRAY of NUMBER>
 * 1: True to show, false to hide <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[86007, 86008], false] call itc_land_common_fnc_ctrlShowMany
 *
 * Public: No
 */

params ["_idcs", "_show"];

{ctrlShow [_x, _show]} forEach _idcs;
