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

params ["_groupID"];
private ["_firstChar","_secondChar","_id","_isAvailableID"];

private _foundID = false;
private _isAvailableID = false;
private _characterHighestIndex = ((count itc_land_datalink_allowedIDCharacters) - 1);
//loop through first char
for "_firstCharIndex" from 0 to _characterHighestIndex do {
  _firstChar = itc_land_datalink_allowedIDCharacters # _firstCharIndex;
  //loop through second char
  if(_isAvailableID) exitWith {};
  for "_secondCharIndex" from 0 to _characterHighestIndex do {
    _secondChar = itc_land_datalink_allowedIDCharacters # _secondCharIndex;
    //generate ID
    _id = _groupID + _firstChar + _secondChar;
    //check if ID is free
    _isAvailableID = !([itc_land_datalink_nodes, _id] call CBA_fnc_hashHasKey);
    //exit if free
    if(_isAvailableID) exitWith {};
  };
};

_id
