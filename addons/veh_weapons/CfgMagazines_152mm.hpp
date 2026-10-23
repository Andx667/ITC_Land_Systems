    class itc_land_g152hex: itc_land_how_mag {
        author = "Toadball";
        displayName = CSTRING(g152hex_DisplayName);
        ammo = "itc_land_155mm";
        muzzleImpulseFactor[] = {15, 30};
        displayNameShort = CSTRING(g152hex_DisplayNameShort);
        itc_land_fuze = "mof35_mod0";
        itc_land_submunition = "itc_land_155mm_helper";
        itc_land_charge_format = "itc_land_g152hex_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 5;
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\g_152\list.sqf);
        itc_land_burstHeight = 15;
    };
    class itc_land_g152hex_chg1: itc_land_g152hex { initSpeed = 103; itc_land_CountInAH = 0;  };
    class itc_land_g152hex_chg2: itc_land_g152hex { initSpeed = 206; itc_land_CountInAH = 0;  };
    class itc_land_g152hex_chg3: itc_land_g152hex { initSpeed = 309; itc_land_CountInAH = 0;  };
    class itc_land_g152hex_chg4: itc_land_g152hex { initSpeed = 412; itc_land_CountInAH = 0;  };
    class itc_land_g152hex_chg5: itc_land_g152hex { initSpeed = 515; itc_land_CountInAH = 0;  };

    class itc_land_g152smo: itc_land_how_mag {
        author = "Toadball";
        displayName = CSTRING(g152smo_DisplayName);
        ammo = "itc_land_155mm_inert";
        muzzleImpulseFactor[] = {15, 30};
        displayNameShort = CSTRING(g152smo_DisplayNameShort);
        itc_land_fuze = "mof35_mod1";
        itc_land_charge_format = "itc_land_g152smo_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 5;
        itc_land_submunition = "itc_land_155mm_smoke";
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\g_152\list.sqf);
        itc_land_burstHeight = 100;
    };
    class itc_land_g152smo_chg1: itc_land_g152smo { initSpeed = 103; itc_land_CountInAH = 0;  };
    class itc_land_g152smo_chg2: itc_land_g152smo { initSpeed = 206; itc_land_CountInAH = 0;   };
    class itc_land_g152smo_chg3: itc_land_g152smo { initSpeed = 309; itc_land_CountInAH = 0;   };
    class itc_land_g152smo_chg4: itc_land_g152smo { initSpeed = 412; itc_land_CountInAH = 0;   };
    class itc_land_g152smo_chg5: itc_land_g152smo { initSpeed = 515; itc_land_CountInAH = 0;   };

    class itc_land_g152icm: itc_land_how_mag {
        author = "Toadball";
        displayName = CSTRING(g152icm_DisplayName);
        ammo = "itc_land_155mm_inert";
        itc_land_submunition = "itc_land_155mm_dpicm_helper";
        muzzleImpulseFactor[] = {15, 30};
        displayNameShort = CSTRING(g152icm_DisplayNameShort);
        itc_land_fuze = "mof35_mod1";
        itc_land_charge_format = "itc_land_g152icm_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 5;
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\g_152\list.sqf);
        itc_land_burstHeight = 400;
    };
    class itc_land_g152icm_chg1: itc_land_g152icm { initSpeed = 103; itc_land_CountInAH = 0;   };
    class itc_land_g152icm_chg2: itc_land_g152icm { initSpeed = 206; itc_land_CountInAH = 0;   };
    class itc_land_g152icm_chg3: itc_land_g152icm { initSpeed = 309; itc_land_CountInAH = 0;   };
    class itc_land_g152icm_chg4: itc_land_g152icm { initSpeed = 412; itc_land_CountInAH = 0;   };
    class itc_land_g152icm_chg5: itc_land_g152icm { initSpeed = 515; itc_land_CountInAH = 0;   };

    class itc_land_g152mat: itc_land_how_mag {
        author = "Toadball";
        displayName = CSTRING(g152mat_DisplayName);
        ammo = "itc_land_155mm_inert";
        muzzleImpulseFactor[] = {15, 30};
        displayNameShort = CSTRING(g152mat_DisplayNameShort);
        itc_land_fuze = "mof35_mod1";
        itc_land_charge_format = "itc_land_g152mat_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 5;
        itc_land_submunition = "itc_land_155mm_fascam_at_helper";
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\g_152\list.sqf);
        itc_land_burstHeight = 300;
    };
    class itc_land_g152mat_chg1: itc_land_g152mat { initSpeed = 103; itc_land_CountInAH = 0;   };
    class itc_land_g152mat_chg2: itc_land_g152mat { initSpeed = 206; itc_land_CountInAH = 0;   };
    class itc_land_g152mat_chg3: itc_land_g152mat { initSpeed = 309; itc_land_CountInAH = 0;   };
    class itc_land_g152mat_chg4: itc_land_g152mat { initSpeed = 412; itc_land_CountInAH = 0;   };
    class itc_land_g152mat_chg5: itc_land_g152mat { initSpeed = 515; itc_land_CountInAH = 0;   };

    class itc_land_g152map: itc_land_how_mag {
        author = "Toadball";
        displayName = CSTRING(g152map_DisplayName);
        ammo = "itc_land_155mm_inert";
        muzzleImpulseFactor[] = {15, 30};
        displayNameShort = CSTRING(g152map_DisplayNameShort);
        itc_land_fuze = "mof35_mod1";
        itc_land_charge_format = "itc_land_g152map_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 5;
        itc_land_submunition = "itc_land_155mm_fascam_ap_helper";
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\g_152\list.sqf);
        itc_land_burstHeight = 400;
    };
    class itc_land_g152map_chg1: itc_land_g152map { initSpeed = 103; itc_land_CountInAH = 0;   };
    class itc_land_g152map_chg2: itc_land_g152map { initSpeed = 206; itc_land_CountInAH = 0;   };
    class itc_land_g152map_chg3: itc_land_g152map { initSpeed = 309; itc_land_CountInAH = 0;   };
    class itc_land_g152map_chg4: itc_land_g152map { initSpeed = 412; itc_land_CountInAH = 0;   };
    class itc_land_g152map_chg5: itc_land_g152map { initSpeed = 515; itc_land_CountInAH = 0;   };

    class itc_land_g152pgm: itc_land_how_mag {
        author = "Toadball";
        displayName = CSTRING(g152pgm_DisplayName);
        ammo = "Sh_155mm_AMOS";
        muzzleImpulseFactor[] = {15, 30};
        displayNameShort = CSTRING(g152pgm_DisplayNameShort);
        itc_land_fuze = "mof35_mod2";
        itc_land_guidance[] = {"gps_inertial",QEFUNC(guidance,pgm15x)};
        itc_land_submunition = "itc_land_155mm_helper";
        itc_land_charge_format = "itc_land_g152pgm_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 5;
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\g_152\list.sqf);
    };
    class itc_land_g152pgm_chg1: itc_land_g152pgm { initSpeed = 103; itc_land_CountInAH = 0;   };
    class itc_land_g152pgm_chg2: itc_land_g152pgm { initSpeed = 206; itc_land_CountInAH = 0;  };
    class itc_land_g152pgm_chg3: itc_land_g152pgm { initSpeed = 309; itc_land_CountInAH = 0;  };
    class itc_land_g152pgm_chg4: itc_land_g152pgm { initSpeed = 412; itc_land_CountInAH = 0;  };
    class itc_land_g152pgm_chg5: itc_land_g152pgm { initSpeed = 515; itc_land_CountInAH = 0;  };

    class itc_land_g152lgm: itc_land_how_mag {
        author = "Toadball";
        displayName = CSTRING(g152lgm_DisplayName);
        ammo = "Sh_155mm_AMOS";
        muzzleImpulseFactor[] = {15, 30};
        displayNameShort = CSTRING(g152lgm_DisplayNameShort);
        itc_land_fuze = "mof35_mod2";
        itc_land_guidance[] = {"laser_coded",QEFUNC(guidance,lgm15x)};
        itc_land_submunition = "itc_land_155mm_helper";
        itc_land_charge_format = "itc_land_g152lgm_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 5;
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\g_152\list.sqf);
    };
    class itc_land_g152lgm_chg1: itc_land_g152lgm { initSpeed = 103; itc_land_CountInAH = 0;  };
    class itc_land_g152lgm_chg2: itc_land_g152lgm { initSpeed = 206; itc_land_CountInAH = 0;  };
    class itc_land_g152lgm_chg3: itc_land_g152lgm { initSpeed = 309; itc_land_CountInAH = 0;  };
    class itc_land_g152lgm_chg4: itc_land_g152lgm { initSpeed = 412; itc_land_CountInAH = 0;  };
    class itc_land_g152lgm_chg5: itc_land_g152lgm { initSpeed = 515; itc_land_CountInAH = 0;  };

    class itc_land_g152ill: itc_land_how_mag {
        author = "Toadball";
        displayName = CSTRING(g152ill_DisplayName);
        ammo = "itc_land_155mm_inert";
        muzzleImpulseFactor[] = {15, 30};
        displayNameShort = CSTRING(g152ill_DisplayNameShort);
        itc_land_fuze = "mof35_mod1";
        itc_land_charge_format = "itc_land_g152ill_chg%1";
        itc_land_CountInAH = 1;
        itc_land_maxChargeIndex = 5;
        itc_land_submunition = "itc_land_155mm_illum";
        itc_land_heightModifier = 600; // aimed at the burst point
        itc_land_btabListFile = QPATHTOEF(ballistics,tables\g_152\list.sqf);
        itc_land_burstHeight = 600;
    };
    class itc_land_g152ill_chg1: itc_land_g152ill { initSpeed = 103; itc_land_CountInAH = 0;  };
    class itc_land_g152ill_chg2: itc_land_g152ill { initSpeed = 206; itc_land_CountInAH = 0;  };
    class itc_land_g152ill_chg3: itc_land_g152ill { initSpeed = 309; itc_land_CountInAH = 0;  };
    class itc_land_g152ill_chg4: itc_land_g152ill { initSpeed = 412; itc_land_CountInAH = 0;  };
    class itc_land_g152ill_chg5: itc_land_g152ill { initSpeed = 515; itc_land_CountInAH = 0;  };
