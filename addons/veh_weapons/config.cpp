#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax","VKing"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common"};
        units[] = {};
        weapons[] = {
            "itc_land_155mm_howitzer",
            "itc_land_152mm_howitzer"
        };
        magazines[] = {
        };
        VERSION_CONFIG;
    };
};


#include "ITC_Land_CfgFuzes.hpp"
#include "CfgAmmo.hpp"
#include "CfgWeapons.hpp"
#include "CfgMagazines.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
