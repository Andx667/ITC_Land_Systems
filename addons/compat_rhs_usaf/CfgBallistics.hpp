class itc_land_ballistics {
    class batteryTypes {
        class RHS_M109_M284 {
            displayName = CSTRING(Battery_M284_DisplayName);
            type = "cannon";
            ammunition[] = {"itc_land_m109hex","itc_land_m109smo","itc_land_m109icm","itc_land_m109mat","itc_land_m109map","itc_land_m109pgm","itc_land_m109lgm","itc_land_m109ill"};
            weaponClass = "itc_land_rhs_weap_m284";
        };
        class RHS_M119 {
            displayName = CSTRING(Battery_M119_DisplayName);
            type = "cannon";
            ammunition[] = {"RHS_mag_m1_he_12","rhs_mag_m314_ilum_4","rhs_mag_m60a2_smoke_4"};
            weaponClass = "RHS_weap_M119";
        };
        // Only the RHS rounds: the vanilla and ACE 82 mm rounds the M252 also fires carry the
        // Mk6 tables, which are made for the Mk6's three charges, not the M252's five
        class RHS_M252 {
            displayName = CSTRING(Battery_M252_DisplayName);
            type = "cannon";
            ammunition[] = {"rhs_1Rnd_m821_HE","rhs_12Rnd_m821_HE"};
            weaponClass = "rhs_mortar_81mm";
        };
    };
};
