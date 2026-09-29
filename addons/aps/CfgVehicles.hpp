#define APS_INIT_EH \
  class EventHandlers: EventHandlers { \
    class ADDON { \
      init = QUOTE(call FUNC(vehicleInit)); \
    }; \
  };

class CfgVehicles {
  // MERKAVA
  class MBT_01_base_F;
  class B_MBT_01_base_F: MBT_01_base_F {
    class EventHandlers;
  };
  class B_MBT_01_cannon_F: B_MBT_01_base_F {
    APS_INIT_EH
    class itc_land_aps {
      class TROPHY_L {
        displayName = "Trophy Left";
        position[] = {-1,0,1.5};
        turret[] = {0};
        direction = -90;
        traverse = 93;
        elevate = 40;
        range = 15;
        munitions = 10;
        pk = 0.8;
        reloadTime = 0.1;
        trigger = 1;
      };
      class TROPHY_R: TROPHY_L {
        displayName = "Trophy Right";
        position[] = {1,0,1.5};
        direction = 90;
      };
    };
  }; // B_MBT_01_cannon_F

  // T-100
  class MBT_02_base_F;
  class O_MBT_02_base_F: MBT_02_base_F {
    class EventHandlers;
  };
  class O_MBT_02_cannon_F: O_MBT_02_base_F {
    APS_INIT_EH
    class itc_land_aps {
      class DROZD_L {
        displayName = "Drozd L";
        direction = -40;
        traverse = 45;
        elevate = 15;
        range = 15;
        munitions = 4;
        pk = 0.3;
        reloadTime = 0.5;
        trigger = 1;
        position[] = {-1,1.5,1};
        turret[] = {0};
      };
      class DROZD_R {
        displayName = "Drozd R";
        direction = 40;
        traverse = 45;
        elevate = 15;
        range = 15;
        munitions = 4;
        pk = 0.3;
        reloadTime = 0.5;
        trigger = 1;
        position[] = {1,1.5,1};
        turret[] = {0};
      };
    };
  }; // B_MBT_01_cannon_F

  // T-14
  class Tank;
  class Tank_F: Tank {
    class EventHandlers;
  };
  class MBT_04_base_F: Tank_F {
    APS_INIT_EH
    class itc_land_aps {
      class AFGHANIT_L {
        displayName = "Afghanit L";
        direction = -50;
        traverse = 55;
        elevate = 10;
        range = 30;
        munitions = 5;
        pk = 0.8;
        reloadTime = 0.1;
        trigger = 1;
        position[] = {-1,1.5,1};
        turret[] = {0};
      };
      class AFGHANIT_R {
        displayName = "Afghanit R";
        direction = 50;
        traverse = 55;
        elevate = 10;
        range = 30;
        munitions = 5;
        pk = 0.8;
        reloadTime = 0.1;
        trigger = 1;
        position[] = {1,1.5,1};
        turret[] = {0};
      };
    };
  }; // MBT_04_base_F
};
