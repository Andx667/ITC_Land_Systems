#define CHARGES(MAG) QUOTE(DOUBLES(MAG,chg1)), QUOTE(DOUBLES(MAG,chg2)), QUOTE(DOUBLES(MAG,chg3)), QUOTE(DOUBLES(MAG,chg4)), QUOTE(DOUBLES(MAG,chg5))

class CfgWeapons {
    class cannon_155mm;
    class rhs_weap_m284: cannon_155mm {
        class Single1;
    };

    // Like itc_land_howitzer_base: one mode, the charge comes from the loaded magazine
    class itc_land_rhs_weap_m284: rhs_weap_m284 {
        scope = 1;
        displayName = "M284";
        autoReload = 0;
        modes[] = {"Single"};
        reloadTime = 1;
        magazineReloadTime = 6;
        magazines[] = {
            CHARGES(itc_land_m109hex),
            CHARGES(itc_land_m109smo),
            CHARGES(itc_land_m109icm),
            CHARGES(itc_land_m109mat),
            CHARGES(itc_land_m109map),
            CHARGES(itc_land_m109pgm),
            CHARGES(itc_land_m109lgm),
            CHARGES(itc_land_m109ill)
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
