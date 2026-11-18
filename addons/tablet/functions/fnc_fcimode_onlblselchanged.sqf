#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Listbox selection-changed handler for the FCI mode selector. Note the
 * function currently exits immediately (disabled); when active it would
 * toggle visibility between the Manual mode controls and the LFCS mode
 * controls based on the selected listbox index.
 *
 * Arguments:
 * 0: Listbox control that triggered the event <Control>
 * 1: Selected listbox index <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [(_this select 0), (_this select 1)] call itc_land_tablet_fnc_fcimode_onlblselchanged
 *
 * Public: No
 */

params [["_control", controlNull, [controlNull]], ["_index", 0, [0]]];
if (true)exitWith{};
//Generate global
GVAR(fcimode) = [_index,lbText [1501,_index]];
GVAR(fcimode_manualidcarray) = [1800,1801,1802,1803,1804,1805,1603];
GVAR(fcimode_lfcsidcarray) = [1018,1010,1400,1011,1401,1012,1402,1100,1101,1601,1602,1600];

switch (GVAR(fcimode) # 0) do {
    case 0: {
        { ctrlShow [_x,true]; } forEach GVAR(fcimode_manualidcarray);    //Show Manual Mode Elements
        { ctrlShow [_x,false]; } forEach GVAR(fcimode_lfcsidcarray); //Hide LFCS Mode Elements
    };
    case 1: {
        //LFCS
        { ctrlShow [_x,false]; } forEach GVAR(fcimode_manualidcarray);   //Hide Manual Mode Elements
        { ctrlShow [_x,true]; } forEach GVAR(fcimode_lfcsidcarray);  //Show LFCS Mode Elements
    };
};
