#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"CUP","Andx"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "itc_land_ballistics", "itc_land_veh_sights", "itc_land_veh_weapons", "ace_interaction", "CUP_Weapons_Ammunition", "CUP_Weapons_VehicleWeapons", "CUP_TrackedVehicles_M270", "CUP_WheeledVehicles_Stryker"};
        // Loaded only when CUP Vehicles is loaded
        skipWhenMissingDependencies = 1;
        units[] = {
            "itc_land_cup_m270_baf_des", "itc_land_cup_m270_baf_wood", "itc_land_cup_m270_hil",
            "itc_land_cup_m270_usa", "itc_land_cup_m270_usmc", "itc_land_cup_m270_aaf", "itc_land_cup_m270_racs",
            "itc_land_cup_m1129_desert", "itc_land_cup_m1129_woodland"
        };
        weapons[] = {"itc_land_cup_m121"};
        VERSION_CONFIG;
    };
};

#include "CfgBallistics.hpp"
#include "CfgMagazines.hpp"
#include "CfgWeapons.hpp"
#include "CfgVehicles.hpp"
