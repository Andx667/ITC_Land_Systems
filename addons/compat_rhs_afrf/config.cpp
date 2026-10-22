#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"RHS","ToadBall","Yax"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "itc_land_ballistics", "itc_land_veh_sights", "itc_land_veh_weapons", "itc_land_sphammohandler", "ace_interaction", "rhs_c_2s1", "rhs_c_2s3", "rhs_c_heavyweapons"};
        // Loaded only when RHS: AFRF is loaded
        skipWhenMissingDependencies = 1;
        units[] = {
            "itc_land_rhsafrf_2s1_tv", "itc_land_rhsafrf_2s1_vmf", "itc_land_rhsafrf_2s3_tv",
            "itc_land_rhsafrf_d30_msv", "itc_land_rhsafrf_d30_vdv", "itc_land_rhsafrf_d30_vmf", "itc_land_rhsafrf_d30_ins",
            "itc_land_rhsafrf_2b14_msv", "itc_land_rhsafrf_2b14_vdv", "itc_land_rhsafrf_2b14_vmf", "itc_land_rhsafrf_2b14_ins",
            "itc_land_rhsafrf_2b14_Gun_Bag", "itc_land_rhsafrf_2b14_Bipod_Bag"
        };
        weapons[] = {"itc_land_rhs_weap_2a31", "itc_land_rhs_weap_2a33"};
        VERSION_CONFIG;
    };
    // Names of the retired standalone compatibility mod, so missions made with it still load
    #define LEGACY_PATCH(NAME) class NAME { \
        units[] = {}; \
        weapons[] = {}; \
        requiredVersion = REQUIRED_VERSION; \
        requiredAddons[] = {QUOTE(ADDON)}; \
        skipWhenMissingDependencies = 1; \
    }
    LEGACY_PATCH(itc_land_rhsafrf_2s1);
    LEGACY_PATCH(itc_land_rhsafrf_2s3);
    LEGACY_PATCH(itc_land_rhsafrf_d30);
    LEGACY_PATCH(itc_land_rhsafrf_2b14);
};

#include "CfgBallistics.hpp"
#include "CfgMagazines.hpp"
#include "CfgWeapons.hpp"
#include "CfgVehicles.hpp"
