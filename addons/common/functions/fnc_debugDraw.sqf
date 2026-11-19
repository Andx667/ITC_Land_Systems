#include "..\script_component.hpp"

/*
 * Author: Andx
 * Draws the debug overlay, called every frame by the Draw3D handler that fnc_debugToggle adds: a label over every
 * vehicle and unit on foot near the camera that a system registered with fnc_registerDebug knows, with that system's
 * lines, then each system's own drawing. Performance is no concern, this is for testing.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_common_fnc_debugDraw
 *
 * Public: No
 */

private _eye = positionCameraToWorld [0, 0, 0];
private _providers = values GVAR(debugProviders);

// crew get no label of their own, a system tells them in their vehicle's label
private _objects = (vehicles + (allUnits select {isNull objectParent _x})) select {_eye distance _x < DEBUG_DISTANCE};

{
    private _object = _x;
    private _lines = [];

    {
        _x params ["_hasSystem", "_getLines"];

        if ([_object] call _hasSystem) then {
            {
                _lines pushBack ([[_x, DEBUG_COLOR_TEXT], _x] select (_x isEqualType []));
            } forEach ([_object] call _getLines);
        };
    } forEach _providers;

    if (_lines isNotEqualTo []) then {
        private _isMan = _object isKindOf "CAManBase";
        private _title = [getText (configOf _object >> "displayName"), name _object] select (_isMan && {isPlayer _object});
        _lines = [[format ["%1 (%2)", _title, typeOf _object], [1, 1, 1, 1]]] + _lines;

        private _top = (_object modelToWorldVisual [0, 0, 0]) vectorAdd [0, 0, [3.5, 2.2] select _isMan];
        private _count = count _lines;

        {
            _x params ["_text", "_color"];
            [_top vectorAdd [0, 0, (_count - 1 - _forEachIndex) * DEBUG_LINE_HEIGHT], _text, _color] call FUNC(debugText);
        } forEach _lines;
    };
} forEach _objects;

{
    [_objects] call (_x select 2);
} forEach _providers;
