class itc_land {
  class apps {
    class spg {
      displayName = "Self Propelled Gun";
      interfaces = "ITC Self Propelled Gun";
      sharedApp = "artillery";
      title = "SPG APP";
      subtitle = "SP Artillery";
      sidebar2 = "INS / DATA";
    };
    class bcs {
      displayName = "Battery Control System";
      interfaces = "-";
    };
    class cbr {
      displayName = "Counter Battery Radar";
      interfaces = "Datalink";
    };
    class missile {
      displayName = "Guided Missile Configuration";
      interfaces = "ITC Self Propelled Gun";
      sharedApp = "artillery";
      title = "MLRS APP";
      subtitle = "MLRS";
      sidebar2 = "STATUS";
    };
  };
};
