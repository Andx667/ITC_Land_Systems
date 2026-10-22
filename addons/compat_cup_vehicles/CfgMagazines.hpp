class CfgMagazines {
    // M1129 Stryker: CUP's 120 mm HE is the vanilla ship cannon round, which fires a 155 mm shell.
    // The ITC Stryker carries its own rounds; CUP's magazines stay as they are.
    class CUP_32Rnd_120mm_HE_M934;
    class itc_land_cup_m121_he: CUP_32Rnd_120mm_HE_M934 {
        displayName = CSTRING(m121_he_DisplayName);
        displayNameShort = CSTRING(m121_he_DisplayNameShort);
        ammo = "itc_land_120mm_mortar";
        itc_land_btabListFile = QPATHTOF(tables\m121\list.sqf);
    };
    class CUP_6Rnd_120mm_Smoke_M929;
    class itc_land_cup_m121_smoke: CUP_6Rnd_120mm_Smoke_M929 {
        displayName = CSTRING(m121_smoke_DisplayName);
        displayNameShort = CSTRING(m121_smoke_DisplayNameShort);
        itc_land_btabListFile = QPATHTOF(tables\m121\list.sqf);
    };
};
