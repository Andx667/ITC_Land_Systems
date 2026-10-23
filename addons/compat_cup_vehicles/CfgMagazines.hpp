class CfgMagazines {
    // M1129 Stryker: CUP's 120 mm HE is the vanilla ship cannon round, which fires a 155 mm shell.
    // The ITC Stryker carries its own rounds, one per magazine with a magazine per charge (the
    // M121's 0.13 / 0.23 / 0.33 of 810 m/s), loaded by the ammunition handler like the ITC guns.
    // CUP's magazines stay as they are.
    class itc_land_how_mag;
    class itc_land_cup_m121_he: itc_land_how_mag {
        author = "ITC Addons Team";
        displayName = CSTRING(m121_he_DisplayName);
        displayNameShort = CSTRING(m121_he_DisplayNameShort);
        ammo = "itc_land_120mm_mortar";
        initSpeed = 810;
        itc_land_fuze = "mof35_mod0";
        itc_land_submunition = "itc_land_120mm_mortar_helper";
        itc_land_burstHeight = 15;
        itc_land_charge_format = "itc_land_cup_m121_he_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 3;
        itc_land_btabListFile = QPATHTOF(tables\m121\list.sqf);
    };
    class itc_land_cup_m121_he_chg1: itc_land_cup_m121_he { initSpeed = 105.3; itc_land_CountInAH = 0; };
    class itc_land_cup_m121_he_chg2: itc_land_cup_m121_he { initSpeed = 186.3; itc_land_CountInAH = 0; };
    class itc_land_cup_m121_he_chg3: itc_land_cup_m121_he { initSpeed = 267.3; itc_land_CountInAH = 0; };

    // vanilla 120 mm smoke shell, bursts into smoke on impact (no ITC fuze)
    class itc_land_cup_m121_smoke: itc_land_how_mag {
        author = "ITC Addons Team";
        displayName = CSTRING(m121_smoke_DisplayName);
        displayNameShort = CSTRING(m121_smoke_DisplayNameShort);
        ammo = "ammo_ShipCannon_120mm_smoke";
        initSpeed = 810;
        itc_land_charge_format = "itc_land_cup_m121_smoke_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 3;
        itc_land_btabListFile = QPATHTOF(tables\m121\list.sqf);
    };
    class itc_land_cup_m121_smoke_chg1: itc_land_cup_m121_smoke { initSpeed = 105.3; itc_land_CountInAH = 0; };
    class itc_land_cup_m121_smoke_chg2: itc_land_cup_m121_smoke { initSpeed = 186.3; itc_land_CountInAH = 0; };
    class itc_land_cup_m121_smoke_chg3: itc_land_cup_m121_smoke { initSpeed = 267.3; itc_land_CountInAH = 0; };
};
