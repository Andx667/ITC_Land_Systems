#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the rover UI dialog: creates the rover camera, populates the
 * aircraft list box, creates the video feed for the current aircraft, restores
 * the FOV slider and vision mode, and starts a per-frame handler that keeps the
 * feed, camera position/target and HUD updated while the dialog is open and the
 * player is alive, tearing everything down once it closes or the player dies.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_rover_fnc_ui_init
 *
 * Public: No
 */

// onLoad fires before the dialog is registered; the IDC-based UI commands below need it active
if (isNull findDisplay 20001) exitWith {
    [{!isNull findDisplay 20001}, FUNC(ui_init), _this] call CBA_fnc_waitUntilAndExecute;
};

GVAR(camera) = "camera" camCreate [0,0,0];
call FUNC(ui_populateListBox);

[GVAR(ui_curAircraft)] call FUNC(createFeed);

sliderSetPosition [1600, 5];
GVAR(ui_camFov) = 0.02 + ((10 - (sliderPosition 1600)) / 10) * 0.33;


if (isNil QGVAR(ui_sliderFov)) then {
    sliderSetPosition [1600, 5];
    GVAR(ui_sliderFov) = (sliderPosition 1600);
};
sliderSetPosition [1600, GVAR(ui_sliderFov)];
GVAR(ui_camFov) = 0.02 + ((10 - (GVAR(ui_sliderFov))) / 10) * 0.33;

if (isNil QGVAR(ui_visMode)) then {
    GVAR(ui_visMode) = "dtv";
};
[GVAR(ui_visMode)] call FUNC(ui_vismode);

[{
    private _plane = GVAR(ui_curAircraft);
    if (!dialog || !alive player) exitWith {
        [_this select 1] call CBA_fnc_removePerFrameHandler;
        call FUNC(killFeed);
        camDestroy GVAR(camera);
    };
    private _illumination = ([] call ace_common_fnc_ambientBrightness);
    ctrlShow [1201, (_illumination < 0.5)];
    if (isNil "_plane") exitWith {
        ctrlShow [2205, true];
        ctrlShow [1004, true];
        ctrlShow [1005, true];
    };
    [_plane] call FUNC(ui_draw);
    ctrlShow [2205, (isNull (laserTarget _plane))];
    ctrlShow [1004, (isNull (laserTarget _plane))];
    ctrlShow [1005, (isNull (laserTarget _plane))];
    if (!(isNull (laserTarget _plane))) then {
        GVAR(camera) camSetPos (_plane modelToWorldVisual GVAR(mempointPos));
        GVAR(camera) camSetTarget (getPos (laserTarget _plane));
        GVAR(camera) camSetFov GVAR(ui_camFov);
    };
    GVAR(camera) camCommit 0;
    }, 0, []] call CBA_fnc_addPerFrameHandler;
