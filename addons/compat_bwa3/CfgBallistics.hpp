class itc_land_ballistics {
    class batteryTypes {
        class BWA3_PZH2000_RH155 {
            displayName = CSTRING(Battery_RH155_DisplayName);
            type = "cannon";
            ammunition[] = {"itc_land_pzh2000hex","itc_land_pzh2000smo","itc_land_pzh2000mat","itc_land_pzh2000pgm","itc_land_pzh2000lgm","itc_land_pzh2000ill"};
            weaponClass = "itc_land_bwa3_weap_RH155";
        };
        class BWA3_MRS120 {
            displayName = CSTRING(Battery_MRS120_DisplayName);
            type = "cannon";
            ammunition[] = {"BWA3_8Rnd_120mm_Mo_shells","BWA3_8Rnd_120mm_Mo_dpz_shells","BWA3_8Rnd_120mm_Mo_annz_shells","BWA3_8Rnd_120mm_Mo_Flare_white","BWA3_8Rnd_120mm_Mo_Smoke_white","BWA3_1Rnd_120mm_Mo_shells","BWA3_1Rnd_120mm_Mo_dpz_shells","BWA3_1Rnd_120mm_Mo_annz_shells","BWA3_1Rnd_120mm_Mo_Flare_white","BWA3_1Rnd_120mm_Mo_Smoke_white"};
            weaponClass = "BWA3_mortar_120mm";
        };
    };
};
