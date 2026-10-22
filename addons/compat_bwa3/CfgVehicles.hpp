/// Magazines macros definition ///

#define mag_2(a) a, a
#define mag_4(a) a, a, a, a
#define mag_6(a) a, a, a, a, a, a
#define mag_8(a) a, a, a, a, a, a, a, a
#define mag_36(a) a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a

#define TURRETS_STUB \
    class Turrets: Turrets { \
        class MainTurret: MainTurret {}; \
    }

// BWMod ties the gun's reload and muzzle flash animations to its own weapon: repointed below.
// The ammunition handler belongs to the loader (BWMod's "gunner 2", turret [0,1]); while that seat is
// empty the gunner runs it, so a smaller crew can still load.
#define ITC_PZH2000 \
    scopeCurator = 2; \
    class ACE_SelfActions: ACE_SelfActions { \
        class ITC_Land_SPHammohandler { \
            displayName = CSTRING(SPHammohandler_DisplayName); \
            condition = "(_target turretUnit [0,1]) == ACE_Player || {isNull (_target turretUnit [0,1]) && {(gunner _target) == ACE_Player}}"; \
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
    class itc_land { \
        tabletInterfaces[] = {"spg"}; \
        mountedTablet = "itc_land_tablet_spg"; \
        loaderType = 2; \
    }; \
    class Turrets: Turrets { \
        class MainTurret: MainTurret { \
            turretInfoType = "ITC_Land_RscAltGunnerSightSPH"; \
            weapons[] = {"itc_land_bwa3_weap_RH155"}; \
            magazines[] = { \
                mag_36("itc_land_pzh2000hex"), \
                mag_8("itc_land_pzh2000smo"), \
                mag_6("itc_land_pzh2000ill"), \
                mag_2("itc_land_pzh2000mat"), \
                mag_4("itc_land_pzh2000pgm"), \
                mag_4("itc_land_pzh2000lgm") \
            }; \
            lockWhenVehicleSpeed = 5; \
            maxHorizontalRotSpeed = ((360/30)/45); \
        }; \
    }; \
    class AnimationSources: AnimationSources { \
        class mainGun_reload: mainGun_reload { \
            weapon = "itc_land_bwa3_weap_RH155"; \
        }; \
        class muzzle_hide_arty: muzzle_hide_arty { \
            weapon = "itc_land_bwa3_weap_RH155"; \
        }; \
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

    // Panzerhaubitze 2000
    class BWA3_Panzerhaubitze2000_base: Tank_F {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
        class AnimationSources {
            class mainGun_reload;
            class muzzle_hide_arty;
        };
    };
    class BWA3_Panzerhaubitze2000_Fleck: BWA3_Panzerhaubitze2000_base {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
    };
    class BWA3_Panzerhaubitze2000_Tropen: BWA3_Panzerhaubitze2000_base {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
    };
    class itc_land_bwa3_pzh2000: BWA3_Panzerhaubitze2000_Fleck {
        displayName = CSTRING(pzh2000_fleck_DisplayName);
        ITC_PZH2000;
    };
    class itc_land_bwa3_pzh2000d: BWA3_Panzerhaubitze2000_Tropen {
        displayName = CSTRING(pzh2000_tropen_DisplayName);
        ITC_PZH2000;
    };
};
