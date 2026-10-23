class page_bcs_firemission_engage:ITC_LAND_Workspace {
    idc = 13505;
    class Controls {
        class itc_land_engage_ammoType_text: ITC_LAND_RscText {
            idc = 7018;
            text = CSTRING(engage_ammoType_text_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.291 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engage_ammoType_input: ITC_LAND_RscComboBox {
            idc = 7100;
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.291 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
            onLBSelChanged = "[""ammoType""] call itc_land_tablet_fnc_pageInteract";
        };
        // fuze and round count for the guns' fire orders (sent with SEND ADJ / SEND FFE)
        class itc_land_engage_fuze_text: ITC_LAND_RscText {
            idc = 7023;
            tooltip = CSTRING(engage_fuze_Tooltip);
            text = CSTRING(engage_fuze_text_Text);
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.313 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engage_fuze_input: ITC_LAND_RscComboBox {
            idc = 7102;
            tooltip = CSTRING(engage_fuze_Tooltip);
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.313 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engage_count_text: ITC_LAND_RscText {
            idc = 7024;
            tooltip = CSTRING(engage_count_Tooltip);
            text = CSTRING(engage_count_text_Text);
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.335 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engage_count_input: ITC_LAND_RscEdit {
            idc = 7404;
            tooltip = CSTRING(engage_count_Tooltip);
            text = "1";
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.335 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engagement_sheaf_text: ITC_LAND_RscText {
            idc = 7019;
            tooltip = CSTRING(engagement_sheaf_Tooltip);
            text = CSTRING(engagement_sheaf_text_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.357 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engagement_sheaf_input: ITC_LAND_RscComboBox {
            idc = 7101;
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.357 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
            onLBSelChanged = "[""sheafType""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_engagement_quick_text: ITC_LAND_RscText {
            idc = 7020;
            tooltip = CSTRING(engagement_quick_Tooltip);
            text = CSTRING(engagement_quick_text_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.379 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engagement_quick_input: ITC_LAND_RscComboBox {
            idc = 7401;
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.379 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engagement_direction_text: ITC_LAND_RscText {
            idc = 7021;
            tooltip = CSTRING(engagement_direction_Tooltip);
            text = CSTRING(engagement_direction_text_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.401 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engagement_direction_input: ITC_LAND_RscEdit {
            idc = 7402;
            text = "0"; //--- ToDo: Localize;
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.401 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engagement_length_text: ITC_LAND_RscText {
            idc = 7022;
            tooltip = CSTRING(engagement_length_Tooltip);
            text = CSTRING(engagement_length_text_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.423 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_engagement_length_input: ITC_LAND_RscEdit {
            idc = 7403;
            text = "0"; //--- ToDo: Localize;
            x = "0.427812 * safezoneW + safezoneX";
            y = "0.423 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_firemission_back: ITC_LAND_RscButton {
            idc = 6603;
            text = CSTRING(firemission_back_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.511 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""back""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_firemission_next: ITC_LAND_RscButton {
            idc = 6602;
            text = CSTRING(firemission_next_Text); //--- ToDo: Localize;
            x = "0.561875 * safezoneW + safezoneX";
            y = "0.511 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""save""] call itc_land_tablet_fnc_pageInteract";
        };
    };
};
