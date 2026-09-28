#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Returns the aircraft currently selected in the rover UI's aircraft list box.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Aircraft currently selected in the list box (index 0 if none selected) <OBJECT>
 *
 * Example:
 * call itc_land_rover_fnc_ui_curPlane
 *
 * Public: No
 */

itc_land_rover_ui_aircraftList # ((lbCurSel 2100) max 0)
