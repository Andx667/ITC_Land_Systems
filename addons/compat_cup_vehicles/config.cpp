#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"CUP","Andx"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "itc_land_veh_sights", "itc_land_veh_weapons", "ace_interaction", "CUP_TrackedVehicles_M270"};
        // Loaded only when CUP Vehicles is loaded
        skipWhenMissingDependencies = 1;
        units[] = {
            "itc_land_cup_m270_baf_des", "itc_land_cup_m270_baf_wood", "itc_land_cup_m270_hil",
            "itc_land_cup_m270_usa", "itc_land_cup_m270_usmc", "itc_land_cup_m270_aaf", "itc_land_cup_m270_racs"
        };
        weapons[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgVehicles.hpp"
