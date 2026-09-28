#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax","VKing"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main"};
        units[] = {};
        weapons[] = {"itc_land_spikeLR"};
        magazines[] = {"itc_land_spikeLR_1rnd"};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "config\baseControls.hpp"
#include "CfgAmmo.hpp"
#include "CfgMagazines.hpp"
#include "CfgWeapons.hpp"
//#include "CfgVehicles.hpp"
#include "config\ace_missileguidance_AttackProfiles.hpp"
#include "config\ITC_Land_SpikeSeeker.hpp"
