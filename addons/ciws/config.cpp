#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "A3_Data_F", "A3_Characters_F", "A3_Air_F", "A3_Armor_F", "A3_Boat_F", "A3_Soft_F", "A3_Air_F_Heli_Heli_Transport_04", "A3_Characters_F_exp", "A3_Props_F_Argo", "A3_Props_F_Orange", "A3_Characters_F_Orange"};
        units[] = {"itc_land_cram_praetorian2","itc_land_cram_praetorian2_o","itc_land_ciws_centurion2"};
        weapons[] = {};
        magazines[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
#include "CfgMagazines.hpp"
#include "CfgAmmo.hpp"
#include "CfgMisc.hpp"

class Extended_FiredBIS_EventHandlers {
    class All {
        class ADDON {
            firedBIS = QUOTE(call FUNC(fired));
        };
    };
};
