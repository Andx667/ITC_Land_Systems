#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_veh_weapons", "itc_land_common"};
        units[] = {};
        weapons[] = {};
        magazines[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "dialogConfig.hpp"
#include "CfgWeapons.hpp"