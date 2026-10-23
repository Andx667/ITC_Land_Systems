    /*
 * Author: ToadBall, Yax, VKing
 * Renders the CBR Map page each frame: draws a directional icon and facing-cone lines for every tracked
 * COBRA vehicle, a red icon labeled with round count for every recorded firing position, and a
 * countdown-to-impact icon for every active inbound shell that has not yet landed.
 *
 * Arguments:
 * 0: The tablet dialog's display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_pageRender;
 *
 * Public: No
 */

    params ["_display"];
    // shared with the HTML tablet's map
    [_display displayCtrl 10001] call itc_land_tablet_fnc_cbrDrawMap;
