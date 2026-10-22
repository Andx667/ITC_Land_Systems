#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"BWMod","Toadball","Andx","Addi"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "itc_land_ballistics", "itc_land_veh_sights", "itc_land_veh_weapons", "itc_land_sphammohandler", "ace_interaction", "bwa3_pzh2000", "bwa3_mrs120"};
        // Loaded only when BWMod is loaded
        skipWhenMissingDependencies = 1;
        units[] = {
            "itc_land_bwa3_pzh2000", "itc_land_bwa3_pzh2000d"
        };
        weapons[] = {"itc_land_bwa3_weap_RH155"};
        VERSION_CONFIG;
    };
};

#include "CfgBallistics.hpp"
#include "CfgMagazines.hpp"
#include "CfgWeapons.hpp"
#include "CfgVehicles.hpp"
