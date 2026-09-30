#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax","VKing"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common"};
        units[] = {};
        weapons[] = {"itc_land_tablet_rover"};
        magazines[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "config\baseControls.hpp"
#include "config\tablet.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
