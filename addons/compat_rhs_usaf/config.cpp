#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"RHS","ToadBall","Yax"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "itc_land_ballistics", "itc_land_veh_sights", "itc_land_veh_weapons", "itc_land_sphammohandler", "ace_interaction", "rhsusf_c_m109", "rhsusf_c_heavyweapons", "rhsusf_c_statics"};
        // Loaded only when RHS: USAF is loaded
        skipWhenMissingDependencies = 1;
        units[] = {
            "itc_land_rhsusf_m109_usarmy", "itc_land_rhsusf_m109d_usarmy",
            "itc_land_rhsusf_m119_d", "itc_land_rhsusf_m119_wd",
            "itc_land_rhsusf_m252_d", "itc_land_rhsusf_m252_wd",
            "itc_rhsusf_M252_Gun_Bag", "itc_rhsusf_M252_Bipod_Bag"
        };
        weapons[] = {"itc_land_rhs_weap_m284"};
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
    LEGACY_PATCH(itc_land_rhsusaf_m109);
    LEGACY_PATCH(itc_land_rhsusaf_m119);
    LEGACY_PATCH(itc_land_rhsusaf_m252);
};

#include "CfgBallistics.hpp"
#include "CfgMagazines.hpp"
#include "CfgWeapons.hpp"
#include "CfgVehicles.hpp"
