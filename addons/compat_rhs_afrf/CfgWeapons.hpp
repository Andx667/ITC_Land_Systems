#define CHARGES(MAG) QUOTE(DOUBLES(MAG,chg1)), QUOTE(DOUBLES(MAG,chg2)), QUOTE(DOUBLES(MAG,chg3)), QUOTE(DOUBLES(MAG,chg4)), QUOTE(DOUBLES(MAG,chg5))

class CfgWeapons {
    class mortar_155mm_AMOS;
    class rhs_weap_2a33: mortar_155mm_AMOS {
        class Single1;
    };
    class rhs_weap_2a31: rhs_weap_2a33 {
        class Single1;
        class EventHandlers;
    };

    // Like itc_land_howitzer_base: one mode, the charge comes from the loaded magazine
    class itc_land_rhs_weap_2a31: rhs_weap_2a31 {
        scope = 1;
        displayName = "2A31";
        autoReload = 0;
        modes[] = {"Single"};
        reloadTime = 1;
        magazineReloadTime = 6;
        magazines[] = {
            CHARGES(itc_land_2a31hex),
            CHARGES(itc_land_2a31smo),
            CHARGES(itc_land_2a31lgm),
            CHARGES(itc_land_2a31ill)
        };
        class Single: Single1 {
            displayName = "";
            artilleryCharge = 1;
            reloadTime = 6;
        };
        // keeps RHS's scripted recoil
        class EventHandlers: EventHandlers {
            class itc_land_veh_weapons {
                fired = QUOTE(call EFUNC(veh_weapons,fired));
            };
            class itc_land_sphammohandler {
                fired = QUOTE(call EFUNC(sphammohandler,firedEH));
            };
        };
    };
    class itc_land_rhs_weap_2a33: rhs_weap_2a33 {
        scope = 1;
        displayName = "2A33";
        autoReload = 0;
        modes[] = {"Single"};
        reloadTime = 1;
        magazineReloadTime = 6;
        magazines[] = {
            CHARGES(itc_land_2a33hex),
            CHARGES(itc_land_2a33smo),
            CHARGES(itc_land_2a33icm),
            CHARGES(itc_land_2a33lgm),
            CHARGES(itc_land_2a33ill)
        };
        class Single: Single1 {
            displayName = "";
            artilleryCharge = 1;
            reloadTime = 6;
        };
        class EventHandlers {
            class itc_land_veh_weapons {
                fired = QUOTE(call EFUNC(veh_weapons,fired));
            };
            class itc_land_sphammohandler {
                fired = QUOTE(call EFUNC(sphammohandler,firedEH));
            };
        };
    };
};
