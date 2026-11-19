#include "..\script_component.hpp"

/*
 * Author: Andx
 * Draws one line of text of the debug overlay in the world. Only valid inside a Draw3D handler.
 *
 * Arguments:
 * 0: Position AGL <ARRAY>
 * 1: Text <STRING>
 * 2: Color RGBA (default: [0.85, 0.85, 0.85, 1]) <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [ASLToAGL _impact, "IMPACT in 12 s", [1, 0.2, 0.2, 1]] call itc_land_common_fnc_debugText
 *
 * Public: No
 */

params [["_position", [0, 0, 0], [[]], 3], ["_text", "", [""]], ["_color", [0.85, 0.85, 0.85, 1], [[]], 4]];

drawIcon3D ["", _color, _position, 0, 0, 0, _text, 2, 0.03, "PuristaMedium", "center"];
