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
class ITC_LAND_RscText;
class ITC_LAND_RscEdit;
class ITC_LAND_RscStructuredText;
class ITC_LAND_RscPicture;
class ITC_LAND_Workspace;
class ITC_LAND_ScrollBar;
class ITC_LAND_RscListBox;
class ITC_LAND_RscComboBox;
class ITC_LAND_RscButton;


//#include "UIconfig\ControlBaseClasses.hpp"
#include "UIconfig\tablet.hpp"

#include "cfgVehicles.hpp"
#include "cfgWeapons.hpp"
#include "cfgMisc.hpp"
