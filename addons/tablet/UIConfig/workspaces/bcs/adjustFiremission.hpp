class page_bcs_firemission_adjust:ITC_LAND_Workspace {
    idc = 13507;
    class Controls {
        class itc_land_firemission_next: ITC_LAND_RscButton {
            idc = 9600;
            text = CSTRING(firemission_next_Text); //--- ToDo: Localize;
            x = "0.561875 * safezoneW + safezoneX";
            y = "0.511 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""save""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_firemission_back: ITC_LAND_RscButton {
            idc = 9604;
            text = CSTRING(firemission_back_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.555 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""back""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_target_field1_text: ITC_LAND_RscText {
            idc = 9020;
            text = CSTRING(target_field1_text_Text); //--- ToDo: Localize;
            tooltip = CSTRING(target_field1_text_Tooltip);
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.379 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_target_field1_input: ITC_LAND_RscEdit {
            idc = 9401;
            text = "0"; //--- ToDo: Localize;
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.379 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_target_field2_input: ITC_LAND_RscEdit {
            idc = 9402;
            text = "0"; //--- ToDo: Localize;
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.401 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_target_field3_input: ITC_LAND_RscEdit {
            idc = 9403;
            text = "0"; //--- ToDo: Localize;
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.423 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_target_field4_input: ITC_LAND_RscEdit {
            idc = 9404;
            text = "0"; //--- ToDo: Localize;
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.445 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_target_field2_text: ITC_LAND_RscText {
            idc = 9021;
            text = CSTRING(target_field2_text_Text); //--- ToDo: Localize;
            tooltip = CSTRING(target_field2_text_Tooltip);
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.401 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_target_field3_text: ITC_LAND_RscText {
            idc = 9022;
            text = CSTRING(target_field3_text_Text); //--- ToDo: Localize;
            tooltip = CSTRING(target_field3_text_Tooltip);
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.423 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_target_field4_text: ITC_LAND_RscText {
            idc = 9023;
            text = CSTRING(target_field4_text_Text); //--- ToDo: Localize;
            tooltip = CSTRING(target_field4_text_Tooltip);
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.445 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
    };
};
