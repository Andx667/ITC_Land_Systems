#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Sets the text of a control on the tablet display.
 *
 * Arguments:
 * 0: Tablet display <Display>
 * 1: Control IDC <Number>
 * 2: Text to set <String>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562, IDC_header1, "Fire Mission"] call itc_land_tablet_fnc_setText
 *
 * Public: No
 */

params ["_display", "_ctrl", "_text"];

(_display displayCtrl _ctrl) ctrlSetText _text;
