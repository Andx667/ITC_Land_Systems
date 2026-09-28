#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Validates a datalink ID string against the configured ID length and allowed character set, and optionally rejects broadcast ("00") group/node combinations.
 *
 * Arguments:
 * 0: Datalink ID to validate <String>
 * 1: Return an array of error strings instead of a plain boolean <Boolean> (default: false)
 * 2: Allow broadcast ("00") group/node combinations <Boolean> (default: false)
 *
 * Return Value:
 * True if the ID is valid <Boolean> (or [Boolean, Array of error Strings] when argument 1 is true)
 *
 * Example:
 * ["0101"] call itc_land_datalink_fnc_validateID
 *
 * Public: No
 */

params ["_IDString",["_returnErrors", false],["_broadCastAllowed",false]];

//initialise return variables
private _isValid = true;
private _errors = [];
//prepare the ID string for checking
private _characterArray = _IDString splitString "";
private _idLength = count _characterArray;

//check if IDs have broadcasting IDs in them
if(!_broadCastAllowed) then {
  private _groupString = [_IDString, 0, 2] call CBA_fnc_substr;
  private _IDString = [_IDString, 2, 2] call CBA_fnc_substr;
  if(_groupString == "00" || _IDString == "00") then {
    _errors pushBack "Illegal broadcasting combination 00 found";
  };
};

//check the ID length
if(count _characterArray != itc_land_datalink_IDLength) then {
  _isValid = false;
  _errors pushBack format["Incorrect ID length %1, expected %2", _idLength, itc_land_datalink_IDLength];
};

//check the ID characters
{
  if(!(_x in itc_land_datalink_allowedIDCharacters)) then {
    _isValid = false;
    _errors pushBack format ["Invalid character %1 at %2", _x, _forEachIndex];
  };
} forEach _characterArray;

//if error handling is on, exit with errors;
if(_returnErrors) exitWith {
  [_isValid, _errors];
};

_isValid
