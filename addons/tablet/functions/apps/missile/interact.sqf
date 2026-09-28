#include "..\..\..\script_component.hpp"

params ["_action"];
_vehicle = [] call EFUNC(common,getCurVehicle);
switch(_action) do {
  case "side1": {
    _vehicle setVariable ["page", "fcs"];
  };
  case "side2": {
    _vehicle setVariable ["page", "status"];
  };
  case "side3": {
    _vehicle setVariable ["page", "status"];
  };  
};
