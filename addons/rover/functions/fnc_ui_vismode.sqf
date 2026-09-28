#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Switches the rover camera's vision mode (day/NVG/white-hot/black-hot) or
 * updates the stored FOV slider value, based on the given UI button id, and
 * remembers the selected vision mode for future dialog opens.
 *
 * Arguments:
 * 0: Vision mode button id: "dtv", "nvg", "whot", "bhot", or "fov" <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["nvg"] call itc_land_rover_fnc_ui_vismode
 *
 * Public: No
 */

params ["_btn"];
switch (_btn) do {
  case "dtv": {
    camUseNVG false;
    false setCamUseTI 0;
  };
  case "nvg": {
    camUseNVG true;
    false setCamUseTI 0;
  };
  case "whot": {
    camUseNVG false;
    true setCamUseTI 0;
  };
  case "bhot": {
    camUseNVG false;
    true setCamUseTI 1;
  };
  case "fov": {
    itc_land_rover_ui_camFov = 0.02 + ((10 - (sliderPosition 1600)) / 10) * 0.33;
    itc_land_rover_ui_sliderFov = (sliderPosition 1600);
  };
};

if (_btn != "fov") then { itc_land_rover_ui_visMode = _btn };
