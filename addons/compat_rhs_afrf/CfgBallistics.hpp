class itc_land_ballistics {
    class batteryTypes {
        class RHS_2S1_2A31 {
            displayName = CSTRING(Battery_2A31_DisplayName);
            type = "cannon";
            ammunition[] = {"itc_land_2a31hex","itc_land_2a31smo","itc_land_2a31lgm","itc_land_2a31ill"};
            weaponClass = "itc_land_rhs_weap_2a31";
            milSystem = 6000;
        };
        class RHS_2S3_2A33 {
            displayName = CSTRING(Battery_2A33_DisplayName);
            type = "cannon";
            ammunition[] = {"itc_land_2a33hex","itc_land_2a33smo","itc_land_2a33icm","itc_land_2a33lgm","itc_land_2a33ill"};
            weaponClass = "itc_land_rhs_weap_2a33";
            milSystem = 6000;
        };
        // D-30 indirect fire rounds; the direct fire and anti-tank rounds have no tables
        class RHS_2A18M {
            displayName = CSTRING(Battery_D30_DisplayName);
            type = "cannon";
            ammunition[] = {"rhs_mag_of462","rhs_mag_of462_10","rhs_mag_3of56","rhs_mag_3of56_10","rhs_mag_3of56_5","rhs_mag_d462","rhs_mag_d462_2","rhs_mag_s463","rhs_mag_s463_2","rhs_mag_3of69m","rhs_mag_3of69m_2"};
            weaponClass = "rhs_weap_d30";
            milSystem = 6000;
        };
        class RHS_2B14 {
            displayName = CSTRING(Battery_2B14_DisplayName);
            type = "cannon";
            ammunition[] = {"rhs_mag_3vo18_10","rhs_mag_3vs25m_10","rhs_mag_53_va_832a_10","rhs_mag_d832du_10"};
            weaponClass = "rhs_weap_2b14";
            milSystem = 6000;
        };
    };
};
