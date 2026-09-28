#include "..\..\..\..\script_component.hpp"

params ["_action"];

switch(_action) do {
  case "cobraConnect": {
    private _id = ctrlText 10400;
    player setVariable ["itc_land_cobra_id",_id];
    [_id,"AB01","cobra","getData",""] call EFUNC(datalink,transmit);
  };
};
