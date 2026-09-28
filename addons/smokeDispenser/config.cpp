#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax","VKing"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main"};
        units[] = {};
        weapons[] = {};
        magazines[] = {"itc_land_smokeDispenser_mag"};
        VERSION_CONFIG;
    };
};

#include "cfgMagazines.hpp"
#include "cfgAmmo.hpp"
#include "config\particles.hpp"
#include "CfgCloudlets.hpp"
