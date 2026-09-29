class CfgVehicles {

    class Man;
  class CAManBase: Man {
    class ACE_SelfActions {
      class ACE_Equipment {
        class ITC_Land_Unpack {
          displayName = "Unpack";
          condition = QUOTE([ACE_player] call FUNC(canunpack));
          statement = "";
          exceptions[] = {"isNotDragging", "notOnMap", "isNotInside", "isNotSitting"};
          showDisabled = 0;
          priority = 0;
        };        
      };
    };
  };

};
