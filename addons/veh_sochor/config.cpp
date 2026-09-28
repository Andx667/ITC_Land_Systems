#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_veh_sights", "itc_land_veh_weapons", "itc_land_sphammohandler"};
        units[] = { "itc_land_o_sph_sochor2","itc_land_o_t_sph_sochor2"};
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
    class Wide: Wide {};
};
#include "CfgVehicles.hpp"
