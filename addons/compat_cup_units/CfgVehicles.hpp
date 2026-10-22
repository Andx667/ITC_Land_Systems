#define TURRETS_STUB \
    class Turrets: Turrets { \
        class MainTurret: MainTurret {}; \
    }

// ITC version of a CUP static gun: ITC sight, no vanilla artillery computer (the BCS replaces it)
#define ITC_STATIC(CUPCLASS,CUPBASE,ITCCLASS,DISPLAYNAME) \
    class CUPCLASS: CUPBASE { \
        TURRETS_STUB; \
    }; \
    class ITCCLASS: CUPCLASS { \
        displayName = DISPLAYNAME; \
        scopeCurator = 2; \
        artilleryScanner = 0; \
        class Turrets: Turrets { \
            class MainTurret: MainTurret { \
                turretInfoType = "ITC_Land_RscGunnerSightBasic"; \
            }; \
        }; \
    }

class CfgVehicles {
    class LandVehicle;
    class StaticWeapon: LandVehicle {
        class Turrets;
    };
    class StaticCannon: StaticWeapon {
        class Turrets: Turrets {
            class MainTurret;
        };
    };
    class CUP_D30_base: StaticCannon {
        TURRETS_STUB;
    };
    class CUP_M119_base: CUP_D30_base {
        TURRETS_STUB;
    };

    // D-30
    ITC_STATIC(CUP_B_D30_AFU,CUP_D30_base,itc_land_cup_d30_afu,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_B_D30_CDF,CUP_D30_base,itc_land_cup_d30_cdf,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_I_D30_TK_GUE,CUP_D30_base,itc_land_cup_d30_tk_gue,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_O_D30_ChDKZ,CUP_D30_base,itc_land_cup_d30_chdkz,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_O_D30_RU,CUP_D30_base,itc_land_cup_d30_ru,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_O_D30_RUS_M_Desert,CUP_D30_base,itc_land_cup_d30_rus_m_desert,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_O_D30_RUS_M_Summer,CUP_D30_base,itc_land_cup_d30_rus_m_summer,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_O_D30_RUS_M_Winter,CUP_D30_base,itc_land_cup_d30_rus_m_winter,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_O_D30_SLA,CUP_D30_base,itc_land_cup_d30_sla,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_O_D30_TK,CUP_D30_base,itc_land_cup_d30_tk,CSTRING(d30_DisplayName));
    ITC_STATIC(CUP_O_D30_TK_INS,CUP_D30_base,itc_land_cup_d30_tk_ins,CSTRING(d30_DisplayName));

    // M119
    ITC_STATIC(CUP_B_M119_HIL,CUP_M119_base,itc_land_cup_m119_hil,CSTRING(m119_DisplayName));
    ITC_STATIC(CUP_B_M119_US,CUP_M119_base,itc_land_cup_m119_us,CSTRING(m119_DisplayName));
    ITC_STATIC(CUP_B_M119_USMC,CUP_M119_base,itc_land_cup_m119_usmc,CSTRING(m119_DisplayName));
    ITC_STATIC(CUP_I_M119_RACS,CUP_M119_base,itc_land_cup_m119_racs,CSTRING(m119_DisplayName));
};
