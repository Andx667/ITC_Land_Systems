/// Magazines macros definition ///

#define mag_5(a) a, a, a, a, a
#define mag_10(a) a, a, a, a, a, a, a, a, a, a
#define mag_24(a) a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a, a

// ITC version of the RCH 155: the Sholef 2's 155 mm L/52 gun and rounds (the real RCH 155 carries the
// PzH 2000's L/52 and loads automatically), ammunition handler, mounted tablet and ITC sight readouts.
// The RCH 155 has a crew of two: its main turret is the commander's seat, so the commander lays the gun.
// The recoil animation is tied to the weapon and follows the ITC gun.
#define ITC_RCH155 \
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
    class itc_land { \
        tabletInterfaces[] = {"spg"}; \
        mountedTablet = "itc_land_tablet_spg"; \
        loaderType = 2; \
    }; \
    class Turrets: Turrets { \
        class MainTurret: MainTurret { \
            turretInfoType = "ITC_Land_RscAltGunnerSightSPH"; \
            weapons[] = {"itc_land_155mm_howitzer", "SmokeLauncher"}; \
            magazines[] = { \
                mag_24("itc_land_g155hex"), \
                mag_10("itc_land_g155smo"), \
                mag_5("itc_land_g155ill"), \
                mag_5("itc_land_g155icm"), \
                mag_5("itc_land_g155pgm"), \
                "SmokeLauncherMag" \
            }; \
            lockWhenVehicleSpeed = 5; \
        }; \
    }; \
    class AnimationSources: AnimationSources { \
        class barrel_recoil: barrel_recoil { \
            weapon = "itc_land_155mm_howitzer"; \
        }; \
    }

class CfgVehicles {
    // Declared as in the vanilla and GTK Boxer configs, so no parent changes
    class LandVehicle;
    class Car: LandVehicle {
        class ACE_SelfActions;
    };
    class Car_F: Car {
        class ACE_SelfActions: ACE_SelfActions {};
        class NewTurret;
    };
    class Wheeled_APC_F: Car_F {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets {
            class MainTurret: NewTurret {};
        };
    };
    class Hawks_GTK_Boxer_base: Wheeled_APC_F {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class Hawks_GTK_Boxer_HMG: Hawks_GTK_Boxer_base {
        class ACE_SelfActions: ACE_SelfActions {};
        class AnimationSources;
    };
    class Hawks_GTK_Boxer_RCH155: Hawks_GTK_Boxer_HMG {
        class ACE_SelfActions: ACE_SelfActions {};
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
        class AnimationSources: AnimationSources {
            class barrel_recoil;
        };
    };
    class Hawks_GTK_Boxer_RCH155_Sand: Hawks_GTK_Boxer_RCH155 {};

    class itc_land_gtk_boxer_rch155: Hawks_GTK_Boxer_RCH155 {
        displayName = CSTRING(rch155_DisplayName);
        ITC_RCH155;
    };
    class itc_land_gtk_boxer_rch155_sand: Hawks_GTK_Boxer_RCH155_Sand {
        displayName = CSTRING(rch155_sand_DisplayName);
        ITC_RCH155;
    };
};
