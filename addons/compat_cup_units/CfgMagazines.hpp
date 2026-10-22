class CfgMagazines {
    // D-30 and M119 fire 810 m/s rounds with the first three vanilla AMOS charges; the other
    // rounds of each gun are child classes and inherit the tables
    class 32Rnd_155mm_Mo_shells;
    class CUP_30Rnd_122mmHE_D30_M: 32Rnd_155mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\amos3\list.sqf);
    };
    // direct fire round with its own speed: no tables
    class CUP_30Rnd_122mmAT_D30_M: CUP_30Rnd_122mmHE_D30_M {
        itc_land_btabListFile = "";
    };
    class CUP_30Rnd_105mmHE_M119_M: 32Rnd_155mm_Mo_shells {
        itc_land_btabListFile = QPATHTOF(tables\amos3\list.sqf);
    };
};
