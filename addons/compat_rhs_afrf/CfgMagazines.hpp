class CfgMagazines {
    // 2S1: 122 mm rounds on the ITC 122 mm framework (ammo, fuzes and g_122 tables)
    class itc_land_g122hex;
    class itc_land_2a31hex: itc_land_g122hex {
        author = "Toadball";
        displayName = CSTRING(2a31hex_DisplayName);
        displayNameShort = CSTRING(2a31hex_DisplayNameShort);
        itc_land_charge_format = "itc_land_2a31hex_chg%1";
    };
    class itc_land_2a31hex_chg1: itc_land_2a31hex { initSpeed = 86; itc_land_CountInAH = 0; };
    class itc_land_2a31hex_chg2: itc_land_2a31hex { initSpeed = 160; itc_land_CountInAH = 0; };
    class itc_land_2a31hex_chg3: itc_land_2a31hex { initSpeed = 240; itc_land_CountInAH = 0; };
    class itc_land_2a31hex_chg4: itc_land_2a31hex { initSpeed = 320; itc_land_CountInAH = 0; };
    class itc_land_2a31hex_chg5: itc_land_2a31hex { initSpeed = 400; itc_land_CountInAH = 0; };

    class itc_land_g122smo;
    class itc_land_2a31smo: itc_land_g122smo {
        author = "Toadball";
        displayName = CSTRING(2a31smo_DisplayName);
        displayNameShort = CSTRING(2a31smo_DisplayNameShort);
        itc_land_charge_format = "itc_land_2a31smo_chg%1";
    };
    class itc_land_2a31smo_chg1: itc_land_2a31smo { initSpeed = 86; itc_land_CountInAH = 0; };
    class itc_land_2a31smo_chg2: itc_land_2a31smo { initSpeed = 160; itc_land_CountInAH = 0; };
    class itc_land_2a31smo_chg3: itc_land_2a31smo { initSpeed = 240; itc_land_CountInAH = 0; };
    class itc_land_2a31smo_chg4: itc_land_2a31smo { initSpeed = 320; itc_land_CountInAH = 0; };
    class itc_land_2a31smo_chg5: itc_land_2a31smo { initSpeed = 400; itc_land_CountInAH = 0; };

    class itc_land_g122lgm;
    class itc_land_2a31lgm: itc_land_g122lgm {
        author = "Toadball";
        displayName = CSTRING(2a31lgm_DisplayName);
        displayNameShort = CSTRING(2a31lgm_DisplayNameShort);
        itc_land_charge_format = "itc_land_2a31lgm_chg%1";
    };
    class itc_land_2a31lgm_chg1: itc_land_2a31lgm { initSpeed = 86; itc_land_CountInAH = 0; };
    class itc_land_2a31lgm_chg2: itc_land_2a31lgm { initSpeed = 160; itc_land_CountInAH = 0; };
    class itc_land_2a31lgm_chg3: itc_land_2a31lgm { initSpeed = 240; itc_land_CountInAH = 0; };
    class itc_land_2a31lgm_chg4: itc_land_2a31lgm { initSpeed = 320; itc_land_CountInAH = 0; };
    class itc_land_2a31lgm_chg5: itc_land_2a31lgm { initSpeed = 400; itc_land_CountInAH = 0; };

    class itc_land_g122ill;
    class itc_land_2a31ill: itc_land_g122ill {
        author = "Toadball";
        displayName = CSTRING(2a31ill_DisplayName);
        displayNameShort = CSTRING(2a31ill_DisplayNameShort);
        itc_land_charge_format = "itc_land_2a31ill_chg%1";
    };
    class itc_land_2a31ill_chg1: itc_land_2a31ill { initSpeed = 86; itc_land_CountInAH = 0; };
    class itc_land_2a31ill_chg2: itc_land_2a31ill { initSpeed = 160; itc_land_CountInAH = 0; };
    class itc_land_2a31ill_chg3: itc_land_2a31ill { initSpeed = 240; itc_land_CountInAH = 0; };
    class itc_land_2a31ill_chg4: itc_land_2a31ill { initSpeed = 320; itc_land_CountInAH = 0; };
    class itc_land_2a31ill_chg5: itc_land_2a31ill { initSpeed = 400; itc_land_CountInAH = 0; };

    // 2S3: 152 mm rounds with the 2A33's own charges and tables
    class itc_land_g152hex;
    class itc_land_2a33hex: itc_land_g152hex {
        author = "Toadball";
        displayName = CSTRING(2a33hex_DisplayName);
        displayNameShort = CSTRING(2a33hex_DisplayNameShort);
        itc_land_charge_format = "itc_land_2a33hex_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\2a33\list.sqf);
    };
    class itc_land_2a33hex_chg1: itc_land_2a33hex { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_2a33hex_chg2: itc_land_2a33hex { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_2a33hex_chg3: itc_land_2a33hex { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_2a33hex_chg4: itc_land_2a33hex { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_2a33hex_chg5: itc_land_2a33hex { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g152smo;
    class itc_land_2a33smo: itc_land_g152smo {
        author = "Toadball";
        displayName = CSTRING(2a33smo_DisplayName);
        displayNameShort = CSTRING(2a33smo_DisplayNameShort);
        itc_land_charge_format = "itc_land_2a33smo_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\2a33\list.sqf);
    };
    class itc_land_2a33smo_chg1: itc_land_2a33smo { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_2a33smo_chg2: itc_land_2a33smo { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_2a33smo_chg3: itc_land_2a33smo { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_2a33smo_chg4: itc_land_2a33smo { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_2a33smo_chg5: itc_land_2a33smo { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g152icm;
    class itc_land_2a33icm: itc_land_g152icm {
        author = "Toadball";
        displayName = CSTRING(2a33icm_DisplayName);
        displayNameShort = CSTRING(2a33icm_DisplayNameShort);
        itc_land_charge_format = "itc_land_2a33icm_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\2a33\list.sqf);
    };
    class itc_land_2a33icm_chg1: itc_land_2a33icm { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_2a33icm_chg2: itc_land_2a33icm { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_2a33icm_chg3: itc_land_2a33icm { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_2a33icm_chg4: itc_land_2a33icm { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_2a33icm_chg5: itc_land_2a33icm { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g152lgm;
    class itc_land_2a33lgm: itc_land_g152lgm {
        author = "Toadball";
        displayName = CSTRING(2a33lgm_DisplayName);
        displayNameShort = CSTRING(2a33lgm_DisplayNameShort);
        itc_land_charge_format = "itc_land_2a33lgm_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\2a33\list.sqf);
    };
    class itc_land_2a33lgm_chg1: itc_land_2a33lgm { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_2a33lgm_chg2: itc_land_2a33lgm { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_2a33lgm_chg3: itc_land_2a33lgm { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_2a33lgm_chg4: itc_land_2a33lgm { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_2a33lgm_chg5: itc_land_2a33lgm { initSpeed = 425; itc_land_CountInAH = 0; };

    class itc_land_g152ill;
    class itc_land_2a33ill: itc_land_g152ill {
        author = "Toadball";
        displayName = CSTRING(2a33ill_DisplayName);
        displayNameShort = CSTRING(2a33ill_DisplayNameShort);
        itc_land_charge_format = "itc_land_2a33ill_chg%1";
        itc_land_btabListFile = QPATHTOF(tables\2a33\list.sqf);
    };
    class itc_land_2a33ill_chg1: itc_land_2a33ill { initSpeed = 85; itc_land_CountInAH = 0; };
    class itc_land_2a33ill_chg2: itc_land_2a33ill { initSpeed = 170; itc_land_CountInAH = 0; };
    class itc_land_2a33ill_chg3: itc_land_2a33ill { initSpeed = 255; itc_land_CountInAH = 0; };
    class itc_land_2a33ill_chg4: itc_land_2a33ill { initSpeed = 340; itc_land_CountInAH = 0; };
    class itc_land_2a33ill_chg5: itc_land_2a33ill { initSpeed = 425; itc_land_CountInAH = 0; };

    // D-30 and 2B14 fire the RHS magazines; their child classes inherit the tables
    class 32Rnd_155mm_Mo_shells;
    class rhs_mag_of462: 32Rnd_155mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\d30\list.sqf);
    };
    class rhs_mag_3vo18_10: 32Rnd_155mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\2b14\list.sqf);
    };
};
