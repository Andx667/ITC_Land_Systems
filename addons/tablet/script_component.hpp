#define COMPONENT tablet
#define COMPONENT_BEAUTIFIED Tablet
#include "\z\itc_land\addons\main\script_mod.hpp"

#include "\z\itc_land\addons\main\script_macros.hpp"

#define ITC_CURVEHICLE private _vehicle = [] call EFUNC(common,getCurVehicle);

// a map grid of 4 to 10 digits (an empty grid is the map origin to ACE)
#define GRID_REGEX "^([0-9][0-9]){2,5}$"
