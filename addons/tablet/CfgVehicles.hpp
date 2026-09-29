class CfgVehicles {
  class Man;
  class CAManBase: Man {
    class ACE_SelfActions {
      class ACE_Equipment {
        class itc_land_tablet_spg {
          displayName = "SPG Tablet";
          condition = "[_player,""itc_land_tablet_spg""] call ace_common_fnc_hasItem";
          statement = QUOTE(['itc_land_tablet_spg'] call FUNC(open));
          icon = QPATHTOF(UI\arty-icon.paa);
          priority = 2.6;
          showDisabled = 1;
          exceptions[] = {"isNotInside","isNotSitting"};
        };
        class itc_land_tablet_fdc {
          displayName = "FDC Tablet";
          condition = "[_player,""itc_land_tablet_fdc""] call ace_common_fnc_hasItem";
          statement = QUOTE(['itc_land_tablet_fdc'] call FUNC(open));
          icon = QPATHTOF(UI\arty-icon.paa);
          priority = 2.6;
          showDisabled = 1;
          exceptions[] = {"isNotInside","isNotSitting"};
        };
      };
    };
  };
/*
  class LandVehicle;
  class Tank : LandVehicle {
    class ACE_SelfActions;
  };
  class Tank_F : Tank {
    class ACE_SelfActions : ACE_SelfActions {
      class ITC_Land_MountedTablet {
        displayName = "Open Mounted Tablet";
        icon = QPATHTOF(UI\arty-icon.paa);
        condition = QUOTE([_target] call FUNC(vehicleHasTablet));
        statement = QUOTE([_target] call FUNC(openVehicleTablet))
      };
    };
  };
 */
};
