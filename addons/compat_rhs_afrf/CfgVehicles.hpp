/// Magazines macros definition ///

#define mag_3(a) a, a, a
#define mag_5(a) a, a, a, a, a
#define mag_28(a) a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a

#define ITC_SPG_ACTIONS \
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
    class itc_land { \
        tabletInterfaces[] = {"spg"}; \
        mountedTablet = "itc_land_tablet_spg"; \
        loaderType = 1; \
    }

#define ITC_STATIC(DISPLAYNAME) \
    displayName = DISPLAYNAME; \
    scopeCurator = 2; \
    artilleryScanner = 0; \
    class Turrets: Turrets { \
        class MainTurret: MainTurret { \
            turretInfoType = "ITC_Land_RscGunnerSightBasic"; \
        }; \
    }

#define ITC_2B14_ASSEMBLY \
    class assembleInfo { \
        primary = 0; \
        base = ""; \
        assembleTo = ""; \
        dissasembleTo[] = {"itc_land_rhsafrf_2b14_Gun_Bag", "itc_land_rhsafrf_2b14_Bipod_Bag"}; \
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
        class AnimationSources;
    };

    // 2S1 Gvozdika
    class rhs_2s1tank_base: Tank_F {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
        class AnimationSources: AnimationSources {
            class reload_source;
            class reload_magazine_source;
            class muzzle_hide_arty;
        };
    };
    class rhs_2s1_tv: rhs_2s1tank_base {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
    };
    class rhs_2s1_vmf: rhs_2s1_tv {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
    };
    #define ITC_2S1_TURRETS \
        class Turrets: Turrets { \
            class MainTurret: MainTurret { \
                turretInfoType = "ITC_Land_RscAltGunnerSightSPH"; \
                weapons[] = {"itc_land_rhs_weap_2a31"}; \
                magazines[] = { \
                    mag_28("itc_land_2a31hex"), \
                    mag_5("itc_land_2a31smo"), \
                    mag_5("itc_land_2a31ill"), \
                    mag_3("itc_land_2a31lgm") \
                }; \
                lockWhenVehicleSpeed = 1; \
                maxHorizontalRotSpeed = ((360/30)/45); \
            }; \
        }
    // RHS ties the recoil and muzzle flash animations to its own weapon
    #define ITC_2S1_ANIMATIONS \
        class AnimationSources: AnimationSources { \
            class reload_source: reload_source { \
                weapon = "itc_land_rhs_weap_2a31"; \
            }; \
            class reload_magazine_source: reload_magazine_source { \
                weapon = "itc_land_rhs_weap_2a31"; \
            }; \
            class muzzle_hide_arty: muzzle_hide_arty { \
                weapon = "itc_land_rhs_weap_2a31"; \
            }; \
        }
    class itc_land_rhsafrf_2s1_tv: rhs_2s1_tv {
        displayName = CSTRING(2s1_DisplayName);
        scopeCurator = 2;
        ITC_SPG_ACTIONS;
        ITC_2S1_TURRETS;
        ITC_2S1_ANIMATIONS;
    };
    class itc_land_rhsafrf_2s1_vmf: rhs_2s1_vmf {
        displayName = CSTRING(2s1_DisplayName);
        scopeCurator = 2;
        ITC_SPG_ACTIONS;
        ITC_2S1_TURRETS;
        ITC_2S1_ANIMATIONS;
    };

    // 2S3 Akatsiya
    class rhs_2s3tank_base: Tank_F {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
        class AnimationSources: AnimationSources {
            class recoil_source;
            class muzzle_hide_arty;
        };
    };
    class rhs_2s3_tv: rhs_2s3tank_base {
        class ACE_SelfActions: ACE_SelfActions {};
        TURRETS_STUB;
    };
    class itc_land_rhsafrf_2s3_tv: rhs_2s3_tv {
        displayName = CSTRING(2s3_DisplayName);
        scopeCurator = 2;
        ITC_SPG_ACTIONS;
        class Turrets: Turrets {
            class MainTurret: MainTurret {
                turretInfoType = "ITC_Land_RscAltGunnerSightSPH";
                weapons[] = {"itc_land_rhs_weap_2a33"};
                magazines[] = {
                    mag_28("itc_land_2a33hex"),
                    mag_5("itc_land_2a33smo"),
                    mag_5("itc_land_2a33ill"),
                    mag_3("itc_land_2a33icm"),
                    mag_3("itc_land_2a33lgm")
                };
                lockWhenVehicleSpeed = 1;
                maxHorizontalRotSpeed = ((360/30)/45);
            };
        };
        // RHS ties the recoil and muzzle flash animations to its own weapon
        class AnimationSources: AnimationSources {
            class recoil_source: recoil_source {
                weapon = "itc_land_rhs_weap_2a33";
            };
            class muzzle_hide_arty: muzzle_hide_arty {
                weapon = "itc_land_rhs_weap_2a33";
            };
        };
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

    // D-30
    class rhs_D30_base: StaticCannon {
        TURRETS_STUB;
    };
    class rhs_D30_msv: rhs_D30_base {
        TURRETS_STUB;
    };
    class rhs_D30_vdv: rhs_D30_base {
        TURRETS_STUB;
    };
    class rhs_D30_vmf: rhs_D30_base {
        TURRETS_STUB;
    };
    class rhs_D30_ins: rhs_D30_base {
        TURRETS_STUB;
    };
    class itc_land_rhsafrf_d30_msv: rhs_D30_msv {
        ITC_STATIC(CSTRING(d30_DisplayName));
    };
    class itc_land_rhsafrf_d30_vdv: rhs_D30_vdv {
        ITC_STATIC(CSTRING(d30_DisplayName));
    };
    class itc_land_rhsafrf_d30_vmf: rhs_D30_vmf {
        ITC_STATIC(CSTRING(d30_DisplayName));
    };
    class itc_land_rhsafrf_d30_ins: rhs_D30_ins {
        ITC_STATIC(CSTRING(d30_DisplayName));
    };

    // 2B14 Podnos, assembled from its own bags
    class rhs_2b14_82mm_Base: StaticMortar {
        TURRETS_STUB;
    };
    class rhs_2b14_82mm_msv: rhs_2b14_82mm_Base {
        TURRETS_STUB;
    };
    class rhs_2b14_82mm_vdv: rhs_2b14_82mm_Base {
        TURRETS_STUB;
    };
    class rhs_2b14_82mm_vmf: rhs_2b14_82mm_Base {
        TURRETS_STUB;
    };
    class rhs_2b14_82mm_ins: rhs_2b14_82mm_Base {
        TURRETS_STUB;
    };
    class itc_land_rhsafrf_2b14_msv: rhs_2b14_82mm_msv {
        ITC_STATIC(CSTRING(2b14_DisplayName));
        ITC_2B14_ASSEMBLY;
    };
    class itc_land_rhsafrf_2b14_vdv: rhs_2b14_82mm_vdv {
        ITC_STATIC(CSTRING(2b14_DisplayName));
        ITC_2B14_ASSEMBLY;
    };
    class itc_land_rhsafrf_2b14_vmf: rhs_2b14_82mm_vmf {
        ITC_STATIC(CSTRING(2b14_DisplayName));
        ITC_2B14_ASSEMBLY;
    };
    class itc_land_rhsafrf_2b14_ins: rhs_2b14_82mm_ins {
        ITC_STATIC(CSTRING(2b14_DisplayName));
        ITC_2B14_ASSEMBLY;
    };

    class RHS_Podnos_Gun_Bag;
    class itc_land_rhsafrf_2b14_Gun_Bag: RHS_Podnos_Gun_Bag {
        displayName = CSTRING(2b14_GunBag_DisplayName);
    };
    class RHS_DShkM_TripodHigh_Bag;
    class RHS_Podnos_Bipod_Bag: RHS_DShkM_TripodHigh_Bag {
        class assembleInfo;
    };
    class itc_land_rhsafrf_2b14_Bipod_Bag: RHS_Podnos_Bipod_Bag {
        displayName = CSTRING(2b14_BipodBag_DisplayName);
        class assembleInfo: assembleInfo {
            displayName = CSTRING(2b14_DisplayName);
            assembleTo = "itc_land_rhsafrf_2b14_msv";
            base[] = {"itc_land_rhsafrf_2b14_Gun_Bag"};
        };
    };
};
