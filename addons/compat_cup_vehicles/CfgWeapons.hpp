#define CHARGES(MAG) QUOTE(DOUBLES(MAG,chg1)), QUOTE(DOUBLES(MAG,chg2)), QUOTE(DOUBLES(MAG,chg3))

class CfgWeapons {
    class mortar_155mm_AMOS;
    class weapon_ShipCannon_120mm: mortar_155mm_AMOS {};
    class CUP_Vmortar_M121: weapon_ShipCannon_120mm {
        class Single1;
    };
    // Like itc_land_howitzer_base: one mode, the charge comes from the loaded magazine.
    // The loader sets the pace (sphammohandler_fnc_loadGun): a dropped round fires at once
    class itc_land_cup_m121: CUP_Vmortar_M121 {
        scope = 1;
        autoReload = 0;
        modes[] = {"Single"};
        reloadTime = 1;
        magazineReloadTime = 0.5;
        magazines[] = {
            CHARGES(itc_land_cup_m121_he),
            CHARGES(itc_land_cup_m121_smoke)
        };
        class Single: Single1 {
            displayName = "";
            artilleryCharge = 1;
            reloadTime = 1;
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
