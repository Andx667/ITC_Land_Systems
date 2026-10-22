#define CHARGES(MAG) QUOTE(DOUBLES(MAG,chg1)), QUOTE(DOUBLES(MAG,chg2)), QUOTE(DOUBLES(MAG,chg3)), QUOTE(DOUBLES(MAG,chg4)), QUOTE(DOUBLES(MAG,chg5))

class CfgWeapons {
    class CannonCore;
    class BWA3_RH155mm_AMOS: CannonCore {
        class Single1;
        class EventHandlers;
    };

    // Like itc_land_howitzer_base: one mode, the charge comes from the loaded magazine
    class itc_land_bwa3_weap_RH155: BWA3_RH155mm_AMOS {
        scope = 1;
        displayName = "RH-155 L/52";
        autoReload = 0;
        modes[] = {"Single"};
        reloadTime = 1;
        magazineReloadTime = 6;
        magazines[] = {
            CHARGES(itc_land_pzh2000hex),
            CHARGES(itc_land_pzh2000smo),
            CHARGES(itc_land_pzh2000mat),
            CHARGES(itc_land_pzh2000pgm),
            CHARGES(itc_land_pzh2000lgm),
            CHARGES(itc_land_pzh2000ill)
        };
        class Single: Single1 {
            displayName = "";
            artilleryCharge = 1;
            reloadTime = 6;
        };
        class EventHandlers: EventHandlers {
            class itc_land_veh_weapons {
                fired = QUOTE(call EFUNC(veh_weapons,fired));
            };
            class itc_land_sphammohandler {
                fired = QUOTE(call EFUNC(sphammohandler,firedEH));
            };
        };
    };
};
