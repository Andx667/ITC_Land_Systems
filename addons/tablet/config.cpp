#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax","VKing"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "itc_land_bcs", "ace_interaction", "ace_interact_menu", "ace_common"};
        units[] = {};
        weapons[] = {"itc_land_tablet_spg","itc_land_tablet_fdc"};
        magazines[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

class ITC_LAND_RscFrame;

#include "UIConfig\ControlBaseClasses.hpp"
#include "UIConfig\tablet.hpp"

#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
#include "CfgMisc.hpp"
