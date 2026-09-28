#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "ace_common", "ace_mk6mortar"};
        units[] = { };
        weapons[] = {};
        VERSION_CONFIG;
    };
};
class RCWSOptics;
class Optics_Armored {
    class Wide: RCWSOptics {};
};
class Optics_Gunner_MBT_01: Optics_Armored {
    class Wide: Wide {};
};
class ITC_Land_Optics_IGS: Optics_Gunner_MBT_01 {
    class Wide: Wide {
        initFov = 0.174;
        minFov = 0.174;
        maxFov = 0.174;
        visionMode[] = {"Normal","NVG"};
        thermalMode[] = {};
        gunnerOpticsModel = "\A3\Weapons_F\Reticle\Optics_Gunner_MBT_01_w_F.p3d";
        gunnerOpticsEffect[] = {};
    };
};


#include "CfgEventHandlers.hpp"
#include "RscInGameUI.hpp"