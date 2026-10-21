class CfgWeapons {
  class ACE_HuntIR_monitor;
  class itc_land_tablet_spg : ACE_HuntIR_monitor {
    displayName = CSTRING(CfgWeapons_tablet_spg_DisplayName);
    descriptionShort = CSTRING(tablet_spg_DescriptionShort);
    picture = QPATHTOF(UI\tableticon256.paa);
    apps[] = {"spg", "bcs"};
    scope = 1;  
  };
  class itc_land_tablet_mlrs : ACE_HuntIR_monitor {
    displayName = CSTRING(tablet_mlrs_DisplayName);
    descriptionShort = CSTRING(tablet_mlrs_DescriptionShort);
    picture = QPATHTOF(UI\tableticon256.paa);
    apps[] = {"missile", "bcs"};
    scope = 1;
  };  
  class itc_land_tablet_fdc : itc_land_tablet_spg {
    displayName = CSTRING(CfgWeapons_tablet_fdc_DisplayName);
    descriptionShort = CSTRING(tablet_fdc_DescriptionShort);
    picture = QPATHTOF(UI\tableticon256.paa);
    apps[] = {"bcs", "cbr"};
    scope = 2;  
  };
};
