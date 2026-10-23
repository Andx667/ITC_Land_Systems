#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        author = AUTHOR;
        authors[] = {"ToadBall","Yax","VKing"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main", "itc_land_main", "itc_land_common", "itc_land_bcs", "itc_land_datalink", "ace_interaction", "ace_interact_menu", "ace_common", "ace_huntir"};
        units[] = {};
        weapons[] = {"itc_land_tablet_spg","itc_land_tablet_fdc"};
        magazines[] = {};
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

// Base controls, defined in itc_land_common (CfgUI.hpp)
class ITC_LAND_RscFrame;
class ITC_LAND_RscText;
class ITC_LAND_RscEdit;
class ITC_LAND_RscStructuredText;
class ITC_LAND_RscPicture;
class ITC_LAND_Workspace;
class ITC_LAND_RscListBox;
class ITC_LAND_RscComboBox;
class ITC_LAND_RscButton;

#include "UIConfig\tablet.hpp"
#include "UIConfig\tablet_web.hpp"

// The HTML tablet page (tablet_fnc_webOpen). A page loaded from a path not listed here renders but
// gets no A3API, so it cannot send anything back. Which spelling the engine matches for an addon
// path is not documented (missions write "ui\\html\\*"): all four until tested
class CfgCommands {
    allowedHTMLLoadURIs[] += {
        "\z\itc_land\addons\tablet\html\*",
        "z\itc_land\addons\tablet\html\*",
        "\\z\\itc_land\\addons\\tablet\\html\\*",
        "z\\itc_land\\addons\\tablet\\html\\*"
    };
};

#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
#include "CfgMisc.hpp"
