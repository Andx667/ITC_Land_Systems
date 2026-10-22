#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"CUP","Andx"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "itc_land_ballistics", "itc_land_veh_sights", "CUP_Weapons_Ammunition", "CUP_Weapons_VehicleWeapons", "CUP_Weapons_StaticWeapons", "CUP_Creatures_StaticWeapons"};
        // Loaded only when CUP Units (with CUP Weapons) is loaded
        skipWhenMissingDependencies = 1;
        units[] = {
            "itc_land_cup_d30_afu", "itc_land_cup_d30_cdf", "itc_land_cup_d30_tk_gue", "itc_land_cup_d30_chdkz",
            "itc_land_cup_d30_ru", "itc_land_cup_d30_rus_m_desert", "itc_land_cup_d30_rus_m_summer", "itc_land_cup_d30_rus_m_winter",
            "itc_land_cup_d30_sla", "itc_land_cup_d30_tk", "itc_land_cup_d30_tk_ins",
            "itc_land_cup_m119_hil", "itc_land_cup_m119_us", "itc_land_cup_m119_usmc", "itc_land_cup_m119_racs"
        };
        weapons[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgBallistics.hpp"
#include "CfgMagazines.hpp"
#include "CfgVehicles.hpp"
