class CfgMagazines {
    // The vanilla 82 mm rounds carry the tables, so every magazine built on them (ACE single
    // rounds, other mods' mortars firing mortar_82mm) gets them too
    class 32Rnd_155mm_Mo_shells;
    class 8Rnd_82mm_Mo_shells: 32Rnd_155mm_Mo_shells {
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\b_82\list.sqf);
    };
    class 8Rnd_82mm_Mo_Flare_white: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\b_82\list.sqf);
    };
    class 8Rnd_82mm_Mo_Flare_white_illumination: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\b_82\list.sqf);
    };
    class 8Rnd_82mm_Mo_Smoke_white: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\b_82\list.sqf);
    };
    class 8Rnd_82mm_Mo_guided: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\b_82\list.sqf);
    };
    class 8Rnd_82mm_Mo_LG: 8Rnd_82mm_Mo_shells {
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\b_82\list.sqf);
    };
    class ACE_1Rnd_82mm_Mo_Illum: 8Rnd_82mm_Mo_Flare_white {
        ammo = "itc_82mm_flare";
    };
};
