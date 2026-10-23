class fci_fuzeinputs: ITC_LAND_RscText {
    idc = 1900;
    tooltip = CSTRING(fci_fuzeinputs_Tooltip);
    text = CSTRING(fci_fuzeinputs_Text);
    sizeEx = 1.125 * GUI_GRID_H;
    x = "0.363125 * safezoneW + safezoneX";
    y = "0.490 * safezoneH + safezoneY";
    w = "0.2 * safezoneW";
    h = "0.033 * safezoneH";
};
class fci_fuzeinputs_text: ITC_LAND_RscText {
    idc = 1901;
    text = CSTRING(fci_fuzeinputs_text_Text);
    x = "0.363125 * safezoneW + safezoneX";
    y = "0.523 * safezoneH + safezoneY";
    w = "0.0735 * safezoneW";
    h = "0.022 * safezoneH";
};
class fci_fuzeinputs_mode_text: ITC_LAND_RscText {
    idc = 1903;
    tooltip = CSTRING(fci_fuzeinputs_mode_Tooltip);
    text = CSTRING(fci_fuzeinputs_mode_text_Text);
    x = "0.363125 * safezoneW + safezoneX";
    y = "0.556 * safezoneH + safezoneY";
    w = "0.0735 * safezoneW";
    h = "0.022 * safezoneH";
};
class fci_fuzeinputs_mode_combo: ITC_LAND_RscComboBox {
    idc = 1904;
    x = "0.393125 * safezoneW + safezoneX";
    y = "0.556 * safezoneH + safezoneY";
    w = "0.0825 * safezoneW";
    h = "0.022 * safezoneH";
    onLBSelChanged = QUOTE(call FUNC(mlrsfci_onlblselchanged_fuzemode));
};

class fci_fuzeinputs_time_text: ITC_LAND_RscText {
    idc = 1905;
    tooltip = CSTRING(fci_fuzeinputs_time_Tooltip);
    text = CSTRING(fci_fuzeinputs_time_text_Text);
    x = "0.363125 * safezoneW + safezoneX";
    y = "0.589 * safezoneH + safezoneY";
    w = "0.0735 * safezoneW";
    h = "0.022 * safezoneH";
};
class fci_fuzeinputs_time_edit: ITC_LAND_RscEdit {
    idc = 1906;
    x = "0.393125 * safezoneW + safezoneX";
    y = "0.589 * safezoneH + safezoneY";
    w = "0.0825 * safezoneW";
    h = "0.022 * safezoneH";
};

class fci_guideinputs_text: ITC_LAND_RscText {
    idc = 1907;
    tooltip = CSTRING(fci_guideinputs_Tooltip);
    text = CSTRING(fci_guideinputs_text_Text);
    x = "0.5 * safezoneW + safezoneX";
    y = "0.523 * safezoneH + safezoneY";
    w = "0.0735 * safezoneW";
    h = "0.022 * safezoneH";
};

class fci_guideinputs_tgtgrid_text: ITC_LAND_RscText {
    idc = 1908;
    tooltip = CSTRING(Grid_Tooltip);
    text = CSTRING(fci_guideinputs_tgtgrid_text_Text);
    x = "0.5 * safezoneW + safezoneX";
    y = "0.556 * safezoneH + safezoneY";
    w = "0.0735 * safezoneW";
    h = "0.022 * safezoneH";
};
class fci_guideinputs_tgtgrid_edit: ITC_LAND_RscEdit {
    idc = 1909;
    x = "0.54 * safezoneW + safezoneX";
    y = "0.556 * safezoneH + safezoneY";
    w = "0.0825 * safezoneW";
    h = "0.022 * safezoneH";
};

class fci_guideinputs_elev_text: ITC_LAND_RscText {
    idc = 1910;
    tooltip = CSTRING(Altitude_Tooltip);
    text = CSTRING(fci_guideinputs_elev_text_Text);
    x = "0.50 * safezoneW + safezoneX";
    y = "0.589 * safezoneH + safezoneY";
    w = "0.0735 * safezoneW";
    h = "0.022 * safezoneH";
};
class fci_guideinputs_elev_edit: ITC_LAND_RscEdit {
    idc = 1911;
    x = "0.54 * safezoneW + safezoneX";
    y = "0.589 * safezoneH + safezoneY";
    w = "0.025 * safezoneW";
    h = "0.022 * safezoneH";
};
/*FOR GLSDB
class fci_guideinputs_aoi_text: ITC_LAND_RscText {
    idc = 1912;
    text = "AOI:";
    x = 0.57 * safezoneW + safezoneX;
    y = 0.589 * safezoneH + safezoneY;
    w = 0.0735 * safezoneW;
    h = 0.022 * safezoneH;
};
class fci_guideinputs_aoi_edit: ITC_LAND_RscEdit {
    idc = 1913;
    x = 0.593 * safezoneW + safezoneX;
    y = 0.589 * safezoneH + safezoneY;
    w = 0.025 * safezoneW;
    h = 0.022 * safezoneH;
};
*/
class fci_guideinputs_apply_btn: ITC_LAND_RscButton {
    idc = 1603;
    text = CSTRING(fci_guideinputs_apply_btn_Text);
    x = "0.393125 * safezoneW + safezoneX";
    y = "0.622 * safezoneH + safezoneY";
    w = "0.0825 * safezoneW";
    h = "0.022 * safezoneH";
    action = "[""setFG""] call itc_land_tablet_fnc_pageInteract";
};
// fills in the FDC's fire orders (round, fuze, fuze setting, GPS target); APPLY stays with the crew
class fci_fdcorders_btn: ITC_LAND_RscButton {
    idc = 1604;
    text = CSTRING(fci_fdcorders_btn_Text);
    tooltip = CSTRING(fci_fdcorders_btn_Tooltip);
    x = "0.480312 * safezoneW + safezoneX";
    y = "0.622 * safezoneH + safezoneY";
    w = "0.0825 * safezoneW";
    h = "0.022 * safezoneH";
    action = "[""fdcOrders""] call itc_land_tablet_fnc_pageInteract";
};
/*class fci_AHinputs_button1: ITC_LAND_RscButton {
    idc = 1918;
    text = "BUTTON 1";
    x = 0.58 * safezoneW + safezoneX;
    y = 0.649 * safezoneH + safezoneY;
    w = 0.0825 * safezoneW;
    h = 0.022 * safezoneH;
};*/
