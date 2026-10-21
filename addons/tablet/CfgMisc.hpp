class itc_land {
  class apps {
    class spg {
      displayName = CSTRING(spg_DisplayName);
      interfaces = "ITC Self Propelled Gun";
      sharedApp = "artillery";
      title = "SPG APP";
      subtitle = "SP Artillery";
      sidebar2 = "INS / DATA";
    };
    class bcs {
      displayName = CSTRING(bcs_DisplayName);
      interfaces = "-";
    };
    class cbr {
      displayName = CSTRING(cbr_DisplayName);
      interfaces = "Datalink";
    };
    class missile {
      displayName = CSTRING(missile_DisplayName);
      interfaces = "ITC Self Propelled Gun";
      sharedApp = "artillery";
      title = "MLRS APP";
      subtitle = "MLRS";
      sidebar2 = "STATUS";
    };
  };
};
