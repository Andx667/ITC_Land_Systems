#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles interactions on the CBR Settings page. On the "cobraConnect" action, reads the entered COBRA ID
 * from the text field, stores it on the player, and transmits a "getData" request to that COBRA unit over the datalink.
 *
 * Arguments:
 * 0: The interaction identifier dispatched from the page's UI controls <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["cobraConnect"] call itc_land_tablet_fnc_pageInteract;
 *
 * Public: No
 */

params ["_action"];

switch(_action) do {
  case "cobraConnect": {
    private _id = ctrlText 10400;
    player setVariable ["itc_land_cobra_id",_id];
    [_id,"AB01","cobra","getData",""] call EFUNC(datalink,transmit);
  };
};
