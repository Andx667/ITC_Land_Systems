#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "A3_Armor_F_Tank_LT_01", "itc_land_veh_sights"};
        units[] = {"itc_land_I_NyxRV"};
        VERSION_CONFIG;
    };
};
#include "CfgVehicles.hpp"
