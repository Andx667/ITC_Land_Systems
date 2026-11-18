#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Finds and returns the next unused datalink ID within a given group by generating candidate IDs from the allowed ID character set and checking them against the current node registry. Server-side only.
 *
 * Arguments:
 * 0: Group ID to search within <String>
 *
 * Return Value:
 * Available datalink ID <String>
 *
 * Example:
 * ["01"] call itc_land_datalink_fnc_findAvailableID
 *
 * Public: No
 */

params [["_groupID", "", [""]]];
private ["_firstChar","_secondChar","_id"];

private _isAvailableID = false;
private _characterHighestIndex = ((count GVAR(allowedIDCharacters)) - 1);
//loop through first char
for "_firstCharIndex" from 0 to _characterHighestIndex do {
    _firstChar = GVAR(allowedIDCharacters) # _firstCharIndex;
    //loop through second char
    if (_isAvailableID) exitWith {};
    for "_secondCharIndex" from 0 to _characterHighestIndex do {
        _secondChar = GVAR(allowedIDCharacters) # _secondCharIndex;
        //generate ID
        _id = _groupID + _firstChar + _secondChar;
        //check if ID is free; node 00 addresses the whole group, so it is never assigned
        _isAvailableID = !(_id in GVAR(nodes)) && {(_firstChar + _secondChar) != "00"};
        //exit if free
        if (_isAvailableID) exitWith {};
    };
};

_id
