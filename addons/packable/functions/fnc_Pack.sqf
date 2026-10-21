#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Packs a deployed item (e.g. a deployed drone/system) back into its
 * carryable item form. Shows a 5 second progress bar with a gesture
 * animation, then deletes it and spawns a ground weapon holder at its
 * position containing one copy of its packed item classname
 * (itc_land_PacksTo).
 *
 * Arguments:
 * 0: Item/object to pack <OBJECT>
 * 1: Unit performing the packing <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_item, _caller] call itc_land_packable_fnc_Pack
 *
 * Public: No
 */

 params ["_item","_caller"];

//get item to pack item to:
private _packed = (configOf _item >> "itc_land_PacksTo") call BIS_fnc_getCfgData;
 private _displayName = (configOf _item >> "displayName") call BIS_fnc_getCfgData;
 private _progtext = format [LLSTRING(Packing),_displayName];

//Pack Darter
[_caller, "MedicOther"] call ace_common_fnc_doGesture;
[
    5,
    [_caller,_item,_packed],
    {
        (_this select 0) params ["_caller","_item","_packed"];
        // deleteVehicle and createVehicle are global, so this works whoever owns the item; read the position before deleting it
        private _pos = getPosATL _item;
        deleteVehicle _item;
        private _holder = createVehicle ["GroundWeaponHolder", _pos, [], 0, "CAN_COLLIDE"];
        _holder addItemCargoGlobal [_packed, 1];
    },
    {},
    _progtext
] call ace_common_fnc_progressBar;
