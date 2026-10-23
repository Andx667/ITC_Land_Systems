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

    // M1129 Stryker mortar carrier: an ITC SPH with ITC 120 mm rounds, no vanilla artillery computer
    // As vanilla (and CUP) declare them: Wheeled_APC_F's Turrets have no parent, its MainTurret is a NewTurret
    class Car: LandVehicle {
        class ACE_SelfActions;
    };
    class Car_F: Car {
        class NewTurret;
        class ACE_SelfActions: ACE_SelfActions {};
    };
    class Wheeled_APC_F: Car_F {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets {
            class MainTurret: NewTurret {};
        };
    };
    class CUP_StrykerBase: Wheeled_APC_F {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class CUP_M1126_ICV_BASE: CUP_StrykerBase {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class CUP_B_M1126_ICV_MK19_Desert: CUP_M1126_ICV_BASE {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class CUP_B_M1129_MC_MK19_Desert: CUP_B_M1126_ICV_MK19_Desert {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets: Turrets {
            class MainTurret: MainTurret {
                class ViewOptics;
            };
            class CargoTurret_01;
        };
    };
    class CUP_B_M1129_MC_MK19_Woodland: CUP_B_M1129_MC_MK19_Desert {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets: Turrets {
            class MainTurret: MainTurret {
                class ViewOptics;
            };
            class CargoTurret_01;
        };
    };
    #define MAG_2(a) a, a
    #define MAG_6(a) MAG_2(a), MAG_2(a), MAG_2(a)
    #define MAG_32(a) MAG_6(a), MAG_6(a), MAG_6(a), MAG_6(a), MAG_6(a), MAG_2(a)
    // an ITC mortar: hand-loaded through the ammunition handler by the loader (or, slower, the gunner alone),
    // laid by hand by the gunner against CA/MA and CQ/MQ in the ITC gunnery sight (IGS, with the alignment guide: CUP's optic is empty);
    // mounted tablet (commander), datalink.
    // The loader seat gets a fixed view: CUP makes it a turret (isPersonTurret 0) without ViewOptics,
    // and the zoom grew with every switch into it.
    // CUP's minElev/maxElev (-5 to 35) count from the barrel raised by elevationOffset (50 degrees, for the sight);
    // elevationLimits[] is the real quadrant it lays, measured on flat ground: 808 to 1519 mils
    #define ITC_M1129 \
        displayName = CSTRING(m1129_DisplayName); \
        scopeCurator = 2; \
        artilleryScanner = 0; \
        class ACE_SelfActions: ACE_SelfActions { \
            class ITC_Land_SPHammohandler { \
                displayName = CSTRING(SPHammohandler_DisplayName); \
                condition = QUOTE([ARR_2(_target,ACE_Player)] call EFUNC(sphammohandler,canOpen)); \
                statement = "[] call itc_land_sphammohandler_fnc_open"; \
            }; \
            class ITC_Land_CommanderTablet { \
                displayName = CSTRING(CommanderTablet_DisplayName); \
                icon = QPATHTOEF(tablet,UI\tableticon256.paa); \
                condition = QUOTE(([_target] call EFUNC(tablet,vehicleHasTablet)) && (( commander _target ) == ACE_Player)); \
                statement = QUOTE([_target] call EFUNC(tablet,openVehicleTablet)); \
            }; \
        }; \
        class itc_land { \
            tabletInterfaces[] = {"spg"}; \
            mountedTablet = "itc_land_tablet_spg"; \
            loaderType = 3; \
            loaderTurret = "CargoTurret_01"; \
            mortarRapidRounds = 16; \
            mortarSustainedRate = 4; \
            elevationLimits[] = {45.45, 85.45}; \
            elevationOffset = 50; \
        }; \
        class Turrets: Turrets { \
            class MainTurret: MainTurret { \
                turretInfoType = "ITC_Land_RscIGS_SPH"; \
                weapons[] = {"itc_land_cup_m121"}; \
                magazines[] = {MAG_32("itc_land_cup_m121_he"), MAG_6("itc_land_cup_m121_smoke")}; \
                lockWhenVehicleSpeed = 5; \
                class ViewOptics: ViewOptics { \
                    initFov = 0.75; \
                    minFov = 0.25; \
                    maxFov = 0.75; \
                }; \
            }; \
            class CargoTurret_01: CargoTurret_01 { \
                gunnerName = CSTRING(m1129_Loader); \
                class ViewOptics { \
                    initAngleX = 0; \
                    minAngleX = -30; \
                    maxAngleX = 30; \
                    initAngleY = 0; \
                    minAngleY = -100; \
                    maxAngleY = 100; \
                    initFov = 1.25; \
                    minFov = 1.25; \
                    maxFov = 1.25; \
                }; \
            }; \
        }
    class itc_land_cup_m1129_desert: CUP_B_M1129_MC_MK19_Desert {
        ITC_M1129;
    };
    class itc_land_cup_m1129_woodland: CUP_B_M1129_MC_MK19_Woodland {
        ITC_M1129;
    };
};
