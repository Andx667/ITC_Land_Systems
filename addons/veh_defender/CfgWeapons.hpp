class CfgWeapons {
  class weapon_mim145Launcher;
  class itc_land_mim145_launcher : weapon_mim145Launcher {
    magazines[] = {"itc_land_mim145_x4"};
    class EventHandlers {
        class itc_land_veh_defender {
            fired = QUOTE(call EFUNC(veh_weapons,fired););
        };
    };
  };
};
