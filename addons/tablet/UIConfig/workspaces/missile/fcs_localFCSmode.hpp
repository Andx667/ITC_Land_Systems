class fcs_target_title: ITC_LAND_RscText {
    idc = 1013;
    text = CSTRING(fcs_target_title_Text);
    x = "0.37625 * safezoneW + safezoneX";
    y = "0.285 * safezoneH + safezoneY";
    w = "0.15 * safezoneW";
    h = "0.033 * safezoneH";
    sizeEx = 1.25 * GUI_GRID_H;
};      
class fcs_target_pos: ITC_LAND_RscText {
  idc = 2510;
    text = CSTRING(fcs_target_pos_Text);
    x = "0.37625 * safezoneW + safezoneX";
    y = "0.329 * safezoneH + safezoneY";
    w = "0.103125 * safezoneW";
    h = "0.022 * safezoneH";
};
class fcs_edit_target_pos: ITC_LAND_RscEdit {
    idc = 2400;
    x = "0.45875 * safezoneW + safezoneX";
    y = "0.329 * safezoneH + safezoneY";
    w = "0.0825 * safezoneW";
    h = "0.022 * safezoneH";
};  
class fcs_target_elev: ITC_LAND_RscText {
    idc = 2511;
    text = CSTRING(fcs_target_elev_Text);
    x = "0.37625 * safezoneW + safezoneX";
    y = "0.362 * safezoneH + safezoneY";
    w = "0.103125 * safezoneW";
    h = "0.022 * safezoneH";
};
class fcs_edit_target_el: ITC_LAND_RscEdit {
    idc = 2401;
    x = "0.45875 * safezoneW + safezoneX";
    y = "0.362 * safezoneH + safezoneY";
    w = "0.0825 * safezoneW";
    h = "0.022 * safezoneH";
};  
class fcs_round_type: ITC_LAND_RscText {
    idc = 2512;
    text = CSTRING(fcs_round_type_Text);
    x = "0.37625 * safezoneW + safezoneX";
    y = "0.395 * safezoneH + safezoneY";
    w = "0.103125 * safezoneW";
    h = "0.022 * safezoneH";
};
class fcs_combo_round_type: ITC_LAND_RscComboBox {
    idc = 2402;
    x = "0.45875 * safezoneW + safezoneX";
    y = "0.395 * safezoneH + safezoneY";
    w = "0.0825 * safezoneW";
    h = "0.022 * safezoneH";
    onLBSelChanged = QUOTE(call FUNC(mlrsfci_onlblselchanged_roundType));                
};
class fcs_results: ITC_LAND_RscStructuredText {
    idc = 2403;
    text = "";
    x = "0.551562 * safezoneW + safezoneX";
    y = "0.285 * safezoneH + safezoneY";
    w = "0.139219 * safezoneW";
    h = "0.18 * safezoneH";
    colorBackground[] = {0,0,0,1};
};
class fcs_results_frame: ITC_LAND_RscFrame {
    idc = 2501;
    text = "";
    x = "0.551562 * safezoneW + safezoneX";
    y = "0.285 * safezoneH + safezoneY";
    w = "0.139219 * safezoneW";
    h = "0.18 * safezoneH";
    colorBackground[] = {0,0,0,0};
};  
class fcs_next: ITC_LAND_RscButton {
    idc = 2601;
    text = CSTRING(fcs_next_Text);
    x = "0.494844 * safezoneW + safezoneX";
    y = "0.432 * safezoneH + safezoneY";
    w = "0.0464063 * safezoneW";
    h = "0.033 * safezoneH";
    action = "[""next""] call itc_land_tablet_fnc_pageInteract";
};
class fcs_prev: ITC_LAND_RscButton {
    idc = 2602;
    text = CSTRING(fcs_prev_Text);
    x = "0.438125 * safezoneW + safezoneX";
    y = "0.432 * safezoneH + safezoneY";
    w = "0.0464063 * safezoneW";
    h = "0.033 * safezoneH";
    action = "[""prev""] call itc_land_tablet_fnc_pageInteract";
};
class fcs_calc: ITC_LAND_RscButton {
    idc = 2600;
    text = CSTRING(fcs_calc_Text);
    x = "0.37625 * safezoneW + safezoneX";
    y = "0.432 * safezoneH + safezoneY";
    w = "0.0515625 * safezoneW";
    h = "0.033 * safezoneH";
    action = "[""calc""] call itc_land_tablet_fnc_pageInteract";
};  
