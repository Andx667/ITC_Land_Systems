#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"Hawkeye","Andx"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "itc_land_ballistics", "itc_land_veh_sights", "itc_land_veh_weapons", "itc_land_sphammohandler", "ace_interaction", "Hawks_GTK_Boxer"};
        // Loaded only when the GTK Boxer is loaded
        skipWhenMissingDependencies = 1;
        units[] = {"itc_land_gtk_boxer_rch155", "itc_land_gtk_boxer_rch155_sand"};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgVehicles.hpp"
