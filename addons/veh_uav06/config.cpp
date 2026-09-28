#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "A3_Air_F_Orange_UAV_06", "itc_land_packable"};
        units[] = {"B_UAV_06_F","O_UAV_06_F","I_UAV_06_F"};
        weapons[] = {"ITC_Land_B_AL6_Packed","ITC_Land_O_AL6_Packed","ITC_Land_I_AL6_Packed"};
        magazines[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
