#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "A3_Air_F_Jets_UAV_05", "itc_land_veh_sights"};
        units[] = {"ITC_Land_B_UAV_UCAVi"};
        VERSION_CONFIG;
    };
};

class NewTurret;

//#include "RscInGameUI.hpp"
//#include "CfgFunctions.hpp"
#include "CfgVehicles.hpp"
