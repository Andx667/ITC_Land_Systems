class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

// Vehicles created by script or Zeus start with their radar off, so switch it on for every CIWS unit
class Extended_Init_EventHandlers {
    class itc_land_cram_praetorian2 {
        class ADDON {
            init = QUOTE(call FUNC(radarOn));
        };
    };
    class itc_land_ciws_centurion2 {
        class ADDON {
            init = QUOTE(call FUNC(radarOn));
        };
    };
};
