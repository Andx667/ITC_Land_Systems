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

itc_land_rover_camera = "camera" camCreate [0,0,0];
call FUNC(ui_populateListBox);

private _feed = [itc_land_rover_ui_curAircraft] call FUNC(createFeed);

sliderSetPosition [1600, 5];
itc_land_rover_ui_camFov = 0.02 + ((10 - (sliderPosition 1600)) / 10) * 0.33;


if (isNil "itc_land_rover_ui_sliderFov") then {
 sliderSetPosition [1600, 5];
 itc_land_rover_ui_sliderFov = (sliderPosition 1600);
};
sliderSetPosition [1600, itc_land_rover_ui_sliderFov];
itc_land_rover_ui_camFov = 0.02 + ((10 - (itc_land_rover_ui_sliderFov)) / 10) * 0.33;

if (isNil "itc_land_rover_ui_visMode") then {
  itc_land_rover_ui_visMode = "dtv";
};
[itc_land_rover_ui_visMode] call FUNC(ui_vismode);

[{
  private _plane = itc_land_rover_ui_curAircraft;
  if(!dialog || !alive player) exitWith {
    [_this select 1] call CBA_fnc_removePerFrameHandler;
    call FUNC(killFeed);
    camDestroy itc_land_rover_camera;
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
    itc_land_rover_camera camSetPos (_plane modelToWorldVisual itc_land_rover_mempointPos);
    itc_land_rover_camera camSetTarget (getPos (laserTarget _plane));
    itc_land_rover_camera camSetFov itc_land_rover_ui_camFov;
  };
  itc_land_rover_camera camCommit 0;
}, 0, []] call CBA_fnc_addPerFrameHandler;
