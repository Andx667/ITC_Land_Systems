/// Magazines macros definition ///

#define mag_2(a) a, a
#define mag_5(a) a, a, a, a, a
#define mag_28(a) a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a

#define ITC_STATIC(DISPLAYNAME) \
    displayName = DISPLAYNAME; \
    scopeCurator = 2; \
    artilleryScanner = 0; \
    class Turrets: Turrets { \
        class MainTurret: MainTurret { \
            turretInfoType = "ITC_Land_RscGunnerSightBasic"; \
        }; \
    }

#define ITC_M252_ASSEMBLY \
    class assembleInfo { \
        primary = 0; \
        base = ""; \
        assembleTo = ""; \
        dissasembleTo[] = {"itc_rhsusf_M252_Bipod_Bag", "itc_rhsusf_M252_Gun_Bag"}; \
        displayName = ""; \
    }

#define TURRETS_STUB \
    class Turrets: Turrets { \
        class MainTurret: MainTurret {}; \
    }

class CfgVehicles {
    class LandVehicle;
    class Tank: LandVehicle {
        class ACE_SelfActions;
    };
    class Tank_F: Tank {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets {
            class MainTurret;
        };
    };
    class MBT_01_base_F: Tank_F {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
    };
    class MBT_01_arty_base_F: MBT_01_base_F {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
        class AnimationSources;
    };

    // M109A6 Paladin
    class rhsusf_m109tank_base: MBT_01_arty_base_F {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
        class AnimationSources: AnimationSources {
            class recoil_source;
        };
    };
    class rhsusf_m109_usarmy: rhsusf_m109tank_base {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
    };
    class rhsusf_m109d_usarmy: rhsusf_m109_usarmy {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
    };
    #define ITC_M109 \
        scopeCurator = 2; \
        class ACE_SelfActions: ACE_SelfActions { \
            class ITC_Land_SPHammohandler { \
                displayName = CSTRING(SPHammohandler_DisplayName); \
                condition = "( gunner _target ) == ACE_Player"; \
                statement = "createDialog 'ITC_Land_SPHammohandler'"; \
            }; \
            class ITC_Land_CommanderTablet { \
                displayName = CSTRING(CommanderTablet_DisplayName); \
                icon = QPATHTOEF(tablet,UI\tableticon256.paa); \
                condition = QUOTE(([_target] call EFUNC(tablet,vehicleHasTablet)) && (( commander _target ) == ACE_Player)); \
                statement = QUOTE([_target] call EFUNC(tablet,openVehicleTablet)); \
            }; \
        }; \
        artilleryScanner = 0; \
        class AnimationSources: AnimationSources { \
            class recoil_source: recoil_source { \
                weapon = "itc_land_rhs_weap_m284"; \
            }; \
        }; \
        class itc_land { \
            tabletInterfaces[] = {"spg"}; \
            mountedTablet = "itc_land_tablet_spg"; \
            loaderType = 1; \
        }; \
        class Turrets: Turrets { \
            class MainTurret: MainTurret { \
                turretInfoType = "ITC_Land_RscAltGunnerSightSPH"; \
                weapons[] = {"itc_land_rhs_weap_m284"}; \
                magazines[] = { \
                    mag_28("itc_land_m109hex"), \
                    mag_5("itc_land_m109smo"), \
                    mag_5("itc_land_m109ill"), \
                    mag_2("itc_land_m109icm"), \
                    "itc_land_m109map", \
                    "itc_land_m109mat", \
                    mag_2("itc_land_m109pgm") \
                }; \
                lockWhenVehicleSpeed = 5; \
                maxHorizontalRotSpeed = ((360/30)/45); \
            }; \
        }
    class itc_land_rhsusf_m109_usarmy: rhsusf_m109_usarmy {
        displayName = CSTRING(m109_wd_DisplayName);
        ITC_M109;
    };
    class itc_land_rhsusf_m109d_usarmy: rhsusf_m109d_usarmy {
        displayName = CSTRING(m109_d_DisplayName);
        ITC_M109;
    };

    class StaticWeapon: LandVehicle {
        class Turrets;
    };
    class StaticCannon: StaticWeapon {
        class Turrets: Turrets {
            class MainTurret;
        };
    };
    class StaticMortar: StaticWeapon {
        class Turrets: Turrets {
            class MainTurret;
        };
    };

    // M119A2
    class RHS_M119_base: StaticCannon {
        TURRETS_STUB;
    };
    class RHS_M119_D: RHS_M119_base {
        TURRETS_STUB;
    };
    class RHS_M119_WD: RHS_M119_base {
        TURRETS_STUB;
    };
    class itc_land_rhsusf_m119_d: RHS_M119_D {
        ITC_STATIC(CSTRING(m119_DisplayName));
    };
    class itc_land_rhsusf_m119_wd: RHS_M119_WD {
        ITC_STATIC(CSTRING(m119_DisplayName));
    };

    // M252, assembled from its own bags
    class RHS_M252_Base: StaticMortar {
        TURRETS_STUB;
    };
    class RHS_M252_D: RHS_M252_Base {
        TURRETS_STUB;
    };
    class RHS_M252_WD: RHS_M252_Base {
        TURRETS_STUB;
    };
    class itc_land_rhsusf_m252_d: RHS_M252_D {
        ITC_STATIC(CSTRING(m252_DisplayName));
        ITC_M252_ASSEMBLY;
    };
    class itc_land_rhsusf_m252_wd: RHS_M252_WD {
        ITC_STATIC(CSTRING(m252_DisplayName));
        ITC_M252_ASSEMBLY;
    };

    class rhs_M252_Gun_Bag;
    class itc_rhsusf_M252_Gun_Bag: rhs_M252_Gun_Bag {
        displayName = CSTRING(m252_GunBag_DisplayName);
    };
    class RHS_M2_Tripod_Bag;
    class rhs_M252_Bipod_Bag: RHS_M2_Tripod_Bag {
        class assembleInfo;
    };
    class itc_rhsusf_M252_Bipod_Bag: rhs_M252_Bipod_Bag {
        displayName = CSTRING(m252_BipodBag_DisplayName);
        class assembleInfo: assembleInfo {
            displayName = CSTRING(m252_DisplayName);
            assembleTo = "itc_land_rhsusf_m252_wd";
            base[] = {"itc_rhsusf_M252_Gun_Bag"};
        };
    };
};
