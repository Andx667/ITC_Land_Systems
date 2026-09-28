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

params ["_control","_index"];
if(true)exitWith{};
//Generate global
itc_land_fcimode = [_index,lbText [1501,_index]];
itc_land_fcimode_manualidcarray = [1800,1801,1802,1803,1804,1805,1603];
itc_land_fcimode_lfcsidcarray = [1012,1010,1400,1011,1401,1012,1402,1100,1101,1601,1602,1600];

switch (itc_land_fcimode # 0) do {
    case 0: {
        { ctrlShow [_x,true]; } forEach itc_land_fcimode_manualidcarray;    //Show Manual Mode Elements
        { ctrlShow [_x,false]; } forEach itc_land_fcimode_lfcsidcarray; //Hide LFCS Mode Elements
    };
    case 1: {
        //LFCS
        { ctrlShow [_x,false]; } forEach itc_land_fcimode_manualidcarray;   //Hide Manual Mode Elements
        { ctrlShow [_x,true]; } forEach itc_land_fcimode_lfcsidcarray;  //Show LFCS Mode Elements
    };
};
