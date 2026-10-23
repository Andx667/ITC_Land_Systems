class itc_land_ballistics {
    class batteryTypes {
        class CUP_M121 {
            displayName = CSTRING(Battery_M121_DisplayName);
            type = "cannon";
            ammunition[] = {"itc_land_cup_m121_he", "itc_land_cup_m121_smoke"};
            weaponClass = "itc_land_cup_m121";
            // the M1129's turret limits count from the raised barrel (see its itc_land >> elevationLimits)
            elevationLimits[] = {45.45, 85.45};
        };
    };
};
