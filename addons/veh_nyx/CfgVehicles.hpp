class CfgVehicles {
    class LandVehicle;
    class Tank: LandVehicle {
        class NewTurret;
    };
    class Tank_F: Tank {
        class Turrets {
            class MainTurret: NewTurret {};
        };
    };
    // the Nyx's only turret is the observer's seat (vanilla calls it the commander), with the laser designator
    class LT_01_base_F: Tank_F {
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class LT_01_scout_base_F: LT_01_base_F {
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class I_LT_01_scout_F: LT_01_scout_base_F {
        class Turrets: Turrets {
            class MainTurret: MainTurret {};
        };
    };
    class itc_land_I_NyxRV: I_LT_01_scout_F {
        displayName = CSTRING(I_NyxRV_DisplayName);
        class Turrets: Turrets {
            class MainTurret: MainTurret {
                turretInfoType = "ITC_Land_RscOptics_strider_commander";
            };
        };
    };
};
