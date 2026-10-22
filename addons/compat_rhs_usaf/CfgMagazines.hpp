class CfgMagazines {
    // M109: 155 mm rounds with the M284's own charges and tables
    class itc_land_g155hex;
    class itc_land_m109hex: itc_land_g155hex {
        author = "Toadball";
        displayName = CSTRING(m109hex_DisplayName);
        displayNameShort = CSTRING(m109hex_DisplayNameShort);
        itc_land_charge_format = "itc_land_m109hex_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\m109\list.sqf);
    };
    class itc_land_m109hex_chg1: itc_land_m109hex { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_m109hex_chg2: itc_land_m109hex { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_m109hex_chg3: itc_land_m109hex { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_m109hex_chg4: itc_land_m109hex { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_m109hex_chg5: itc_land_m109hex { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g155smo;
    class itc_land_m109smo: itc_land_g155smo {
        author = "Toadball";
        displayName = CSTRING(m109smo_DisplayName);
        displayNameShort = CSTRING(m109smo_DisplayNameShort);
        itc_land_charge_format = "itc_land_m109smo_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\m109\list.sqf);
    };
    class itc_land_m109smo_chg1: itc_land_m109smo { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_m109smo_chg2: itc_land_m109smo { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_m109smo_chg3: itc_land_m109smo { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_m109smo_chg4: itc_land_m109smo { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_m109smo_chg5: itc_land_m109smo { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g155icm;
    class itc_land_m109icm: itc_land_g155icm {
        author = "Toadball";
        displayName = CSTRING(m109icm_DisplayName);
        displayNameShort = CSTRING(m109icm_DisplayNameShort);
        itc_land_charge_format = "itc_land_m109icm_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\m109\list.sqf);
    };
    class itc_land_m109icm_chg1: itc_land_m109icm { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_m109icm_chg2: itc_land_m109icm { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_m109icm_chg3: itc_land_m109icm { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_m109icm_chg4: itc_land_m109icm { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_m109icm_chg5: itc_land_m109icm { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g155mat;
    class itc_land_m109mat: itc_land_g155mat {
        author = "Toadball";
        displayName = CSTRING(m109mat_DisplayName);
        displayNameShort = CSTRING(m109mat_DisplayNameShort);
        itc_land_charge_format = "itc_land_m109mat_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\m109\list.sqf);
    };
    class itc_land_m109mat_chg1: itc_land_m109mat { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_m109mat_chg2: itc_land_m109mat { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_m109mat_chg3: itc_land_m109mat { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_m109mat_chg4: itc_land_m109mat { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_m109mat_chg5: itc_land_m109mat { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g155map;
    class itc_land_m109map: itc_land_g155map {
        author = "Toadball";
        displayName = CSTRING(m109map_DisplayName);
        displayNameShort = CSTRING(m109map_DisplayNameShort);
        itc_land_charge_format = "itc_land_m109map_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\m109\list.sqf);
    };
    class itc_land_m109map_chg1: itc_land_m109map { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_m109map_chg2: itc_land_m109map { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_m109map_chg3: itc_land_m109map { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_m109map_chg4: itc_land_m109map { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_m109map_chg5: itc_land_m109map { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g155pgm;
    class itc_land_m109pgm: itc_land_g155pgm {
        author = "Toadball";
        displayName = CSTRING(m109pgm_DisplayName);
        displayNameShort = CSTRING(m109pgm_DisplayNameShort);
        itc_land_charge_format = "itc_land_m109pgm_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\m109\list.sqf);
    };
    class itc_land_m109pgm_chg1: itc_land_m109pgm { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_m109pgm_chg2: itc_land_m109pgm { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_m109pgm_chg3: itc_land_m109pgm { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_m109pgm_chg4: itc_land_m109pgm { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_m109pgm_chg5: itc_land_m109pgm { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g155lgm;
    class itc_land_m109lgm: itc_land_g155lgm {
        author = "Toadball";
        displayName = CSTRING(m109lgm_DisplayName);
        displayNameShort = CSTRING(m109lgm_DisplayNameShort);
        itc_land_charge_format = "itc_land_m109lgm_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\m109\list.sqf);
    };
    class itc_land_m109lgm_chg1: itc_land_m109lgm { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_m109lgm_chg2: itc_land_m109lgm { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_m109lgm_chg3: itc_land_m109lgm { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_m109lgm_chg4: itc_land_m109lgm { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_m109lgm_chg5: itc_land_m109lgm { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g155ill;
    class itc_land_m109ill: itc_land_g155ill {
        author = "Toadball";
        displayName = CSTRING(m109ill_DisplayName);
        displayNameShort = CSTRING(m109ill_DisplayNameShort);
        itc_land_charge_format = "itc_land_m109ill_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\m109\list.sqf);
    };
    class itc_land_m109ill_chg1: itc_land_m109ill { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_m109ill_chg2: itc_land_m109ill { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_m109ill_chg3: itc_land_m109ill { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_m109ill_chg4: itc_land_m109ill { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_m109ill_chg5: itc_land_m109ill { initSpeed = 425; itc_land_CountInAH = 0; };

    // M119 and M252 fire the RHS magazines; their child classes inherit the tables
    class 32Rnd_155mm_Mo_shells;
    class RHS_mag_m1_he_12: 32Rnd_155mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\m119\list.sqf);
    };
    class 8Rnd_82mm_Mo_shells;
    class rhs_1Rnd_m821_HE: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\m252\list.sqf);
    };
};
