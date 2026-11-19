#define COMPONENT cobra
#define COMPONENT_BEAUTIFIED Cobra
#include "\z\itc_land\addons\main\script_mod.hpp"

#include "\z\itc_land\addons\main\script_macros.hpp"

// Debug overlay: the direction the scan (fnc_scan) reads from the turret, and the half-width of its arc in degrees
#define DEBUG_FACING(cobra) (getDir cobra - deg (cobra animationPhase "mainTurret"))
#define DEBUG_ARC 23
// distance (m) up to which predicted impacts and firing positions are shown
#define DEBUG_POINT_DISTANCE 5000
