#define STUB \
    class ACE_SelfActions: ACE_SelfActions {}; \
    class Turrets: Turrets { \
        class MainTurret: MainTurret {}; \
    }

// ITC version of a CUP M270, set up like the Seara 2: ITC 230 mm rockets, MLRS sight and tablet
#define ITC_M270(CUPCLASS,ITCCLASS) \
    class CUPCLASS: CUP_M270_HE_Base { \
        STUB; \
    }; \
    class ITCCLASS: CUPCLASS { \
        displayName = CSTRING(m270_DisplayName); \
        scopeCurator = 2; \
        artilleryScanner = 0; \
        class ACE_SelfActions: ACE_SelfActions { \
            class ITC_Land_CommanderTablet { \
                displayName = CSTRING(CommanderTablet_DisplayName); \
                icon = QPATHTOEF(tablet,UI\tableticon256.paa); \
                condition = QUOTE(([_target] call EFUNC(tablet,vehicleHasTablet)) && (( gunner _target ) == ACE_Player)); \
                statement = QUOTE([_target] call EFUNC(tablet,openVehicleTablet)); \
            }; \
        }; \
        class itc_land { \
            tabletInterfaces[] = {"spg"}; \
            mountedTablet = "itc_land_tablet_mlrs"; \
        }; \
        class Turrets: Turrets { \
            class MainTurret: MainTurret { \
                turretInfoType = "ITC_Land_RscGunnerSightMLRS"; \
                lockWhenVehicleSpeed = 5; \
                weapons[] = {"itc_land_230mm_mlrs"}; \
                magazines[] = {"itc_land_m230icm_12rnd", "itc_land_m230pgm_12rnd"}; \
            }; \
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
    class CUP_M270_HE_Base: Tank_F {
        STUB;
    };

    ITC_M270(CUP_B_M270_HE_BAF_DES,itc_land_cup_m270_baf_des);
    ITC_M270(CUP_B_M270_HE_BAF_WOOD,itc_land_cup_m270_baf_wood);
    ITC_M270(CUP_B_M270_HE_HIL,itc_land_cup_m270_hil);
    ITC_M270(CUP_B_M270_HE_USA,itc_land_cup_m270_usa);
    ITC_M270(CUP_B_M270_HE_USMC,itc_land_cup_m270_usmc);
    ITC_M270(CUP_I_M270_HE_AAF,itc_land_cup_m270_aaf);
    ITC_M270(CUP_I_M270_HE_RACS,itc_land_cup_m270_racs);

    // M1129 Stryker mortar carrier: ITC 120 mm rounds, ITC sight, no vanilla artillery computer
    // As vanilla (and CUP) declare them: Wheeled_APC_F's Turrets have no parent, its MainTurret is a NewTurret
    class Car;
    class Car_F: Car {
        class NewTurret;
    };
    class Wheeled_APC_F: Car_F {
        class Turrets {
            class MainTurret: NewTurret {};
        };
    };
    class CUP_StrykerBase: Wheeled_APC_F {
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class CUP_M1126_ICV_BASE: CUP_StrykerBase {
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class CUP_B_M1126_ICV_MK19_Desert: CUP_M1126_ICV_BASE {
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class CUP_B_M1129_MC_MK19_Desert: CUP_B_M1126_ICV_MK19_Desert {
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class CUP_B_M1129_MC_MK19_Woodland: CUP_B_M1129_MC_MK19_Desert {
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    #define ITC_M1129 \
        displayName = CSTRING(m1129_DisplayName); \
        scopeCurator = 2; \
        artilleryScanner = 0; \
        class Turrets: Turrets { \
            class MainTurret: MainTurret { \
                turretInfoType = "ITC_Land_RscGunnerSightBasic"; \
                weapons[] = {"itc_land_cup_m121"}; \
                magazines[] = {"itc_land_cup_m121_he", "itc_land_cup_m121_smoke"}; \
            }; \
        }
    class itc_land_cup_m1129_desert: CUP_B_M1129_MC_MK19_Desert {
        ITC_M1129;
    };
    class itc_land_cup_m1129_woodland: CUP_B_M1129_MC_MK19_Woodland {
        ITC_M1129;
    };
};
