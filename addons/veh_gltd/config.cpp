#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_packable"};
        units[] = {"ITC_Land_B_RemoteGLTD", "ITC_Land_BW_RemoteGLTD"};
        weapons[] = {"ITC_Land_B_RemoteGLTD_Packed","ITC_Land_BW_RemoteGLTD_Packed"};
        magazines[] = {};
        VERSION_CONFIG;
    };
};

class NewTurret;
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
