#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax","VKing"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "A3_Weapons_F_Sams", "itc_land_veh_weapons"};
        units[] = { "itc_land_b_defender2"};
        weapons[] = {};
        VERSION_CONFIG;
    };
};

#include "cfgVehicles.hpp"
#include "cfgWeapons.hpp"
#include "cfgMagazines.hpp"
#include "cfgAmmo.hpp"
