#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "A3_Drones_F_Air_F_Gamma_UAV_02", "itc_land_veh_sights"};
        units[] = {"ITC_Land_B_UAV_MQ4i","ITC_Land_O_UAV_K40i","ITC_Land_I_UAV_K40i"};
        VERSION_CONFIG;
    };
};

class NewTurret;

//#include "RscInGameUI.hpp"
//#include "CfgFunctions.hpp"
#include "CfgVehicles.hpp"
