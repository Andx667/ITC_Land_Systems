#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "A3_Soft_F_Beta_MRAP_03", "itc_land_veh_sights"};
        units[] = {"itc_land_I_StriderRV","itc_land_I_StriderRV_HMG","itc_land_I_StriderRV_GMG"};
        VERSION_CONFIG;
    };
};
class NewTurret;
#include "CfgVehicles.hpp"
