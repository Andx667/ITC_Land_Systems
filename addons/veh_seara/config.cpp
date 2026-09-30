#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "A3_Armor_F_Gamma_MBT_01", "itc_land_veh_sights", "itc_land_veh_weapons"};
        units[] = {"itc_land_b_mlrs_seara2","itc_land_b_t_mlrs_seara2"};
        weapons[] = {};
        magazines[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgVehicles.hpp"
