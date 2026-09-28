#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_veh_sights", "itc_land_veh_weapons", "itc_land_ciws"};
        units[] = {"itc_land_b_vls2","itc_land_b_vls2_slam"};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "cfgVehicles.hpp"
#include "cfgWeapons.hpp"
#include "cfgMagazines.hpp"
#include "cfgAmmo.hpp"
#include "cfgDisplay.hpp"
