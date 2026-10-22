// PzH 2000: German designations on the ITC 155 mm L/52 rounds (charges, fuzes, g_155 tables)
// Class names as in the TTT mod (itc_land_pzh2000hex, ...), so its missions keep working
#define PZH_ROUND(SUFFIX,BASE) \
    class BASE; \
    class itc_land_pzh2000##SUFFIX: BASE { \
        author = "Toadball"; \
        displayName = CSTRING(DOUBLES(SUFFIX,DisplayName)); \
        displayNameShort = CSTRING(DOUBLES(SUFFIX,DisplayNameShort)); \
        itc_land_charge_format = QUOTE(itc_land_pzh2000##SUFFIX##_chg%1); \
    }; \
    class itc_land_pzh2000##SUFFIX##_chg1: itc_land_pzh2000##SUFFIX { initSpeed = 100; itc_land_CountInAH = 0; }; \
    class itc_land_pzh2000##SUFFIX##_chg2: itc_land_pzh2000##SUFFIX { initSpeed = 200; itc_land_CountInAH = 0; }; \
    class itc_land_pzh2000##SUFFIX##_chg3: itc_land_pzh2000##SUFFIX { initSpeed = 300; itc_land_CountInAH = 0; }; \
    class itc_land_pzh2000##SUFFIX##_chg4: itc_land_pzh2000##SUFFIX { initSpeed = 400; itc_land_CountInAH = 0; }; \
    class itc_land_pzh2000##SUFFIX##_chg5: itc_land_pzh2000##SUFFIX { initSpeed = 500; itc_land_CountInAH = 0; }

class CfgMagazines {
    PZH_ROUND(hex,itc_land_g155hex);
    PZH_ROUND(smo,itc_land_g155smo);
    PZH_ROUND(mat,itc_land_g155mat);
    PZH_ROUND(pgm,itc_land_g155pgm);
    PZH_ROUND(lgm,itc_land_g155lgm);
    PZH_ROUND(ill,itc_land_g155ill);

    // MRS120: BWMod builds its 120 mm rounds on the vanilla 82 mm ones, which carry the Mk6
    // tables, so each needs its own; the 1Rnd versions inherit from these
    class 8Rnd_82mm_Mo_shells;
    class 8Rnd_82mm_Mo_Smoke_white;
    class BWA3_8Rnd_120mm_Mo_shells: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\mrs120\list.sqf);
    };
    class BWA3_8Rnd_120mm_Mo_dpz_shells: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\mrs120\list.sqf);
    };
    class BWA3_8Rnd_120mm_Mo_annz_shells: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\mrs120\list.sqf);
    };
    class BWA3_8Rnd_120mm_Mo_Flare_white: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\mrs120\list.sqf);
    };
    class BWA3_8Rnd_120mm_Mo_Smoke_white: 8Rnd_82mm_Mo_Smoke_white {
        itc_land_btabListFile = QPATHTOF(tables\mrs120\list.sqf);
    };
};
