class page_bcs_settings:ITC_LAND_Workspace {
    idc = 13501;
    class Controls {
        class bcs_settings_alerttosplash_label: ITC_LAND_RscText {
            idc = 3201;
            tooltip = CSTRING(bcs_settings_alerttosplash_Tooltip);
            text = CSTRING(bcs_settings_alerttosplash_label_Text);
            x = QUOTE((0.407187 + POSXADJUST) * safezoneW + safezoneX);
            y = QUOTE((0.313 + POSYADJUST) * safezoneH + safezoneY);
            w = "0.061875 * safezoneW";
            h = "0.022 * safezoneH";

        };
        class bcs_settings_firemission_code_label: ITC_LAND_RscText {
            idc = 3203;
            tooltip = CSTRING(bcs_settings_firemission_code_Tooltip);
            text = CSTRING(bcs_settings_firemission_code_label_Text);
            x = QUOTE((0.407187 + POSXADJUST) * safezoneW + safezoneX);
            y = QUOTE((0.379 + POSYADJUST) * safezoneH + safezoneY);
            w = "0.0670312 * safezoneW";
            h = "0.022 * safezoneH";

        };
        class bcs_settings_firemission_start_label: ITC_LAND_RscText {
            idc = 3204;
            tooltip = CSTRING(bcs_settings_firemission_start_Tooltip);
            text = CSTRING(bcs_settings_firemission_start_label_Text);
            x = QUOTE((0.407187 + POSXADJUST) * safezoneW + safezoneX);
            y = QUOTE((0.412 + POSYADJUST) * safezoneH + safezoneY);
            w = "0.0670312 * safezoneW";
            h = "0.022 * safezoneH";

        };
        class bcs_settings_alerttosplash_text: ITC_LAND_RscEdit {
            idc = 3205;
            text = "5";
            x = QUOTE((0.479375 + POSXADJUST) * safezoneW + safezoneX);
            y = QUOTE((0.313 + POSYADJUST) * safezoneH + safezoneY);
            w = "0.0721875 * safezoneW";
            h = "0.022 * safezoneH";

            key = "splashTime";
            setMethod = "ctrlSetText";

            colorBackground[] = {0,0,0,1};
            colorActive[] = {0,0,0,1};
        };
        class bcs_settings_firemission_code_text: ITC_LAND_RscEdit {
            idc = 3206;
            text = CSTRING(bcs_settings_firemission_code_text_Text);
            x = QUOTE((0.479375 + POSXADJUST) * safezoneW + safezoneX);
            y = QUOTE((0.379 + POSYADJUST) * safezoneH + safezoneY);
            w = "0.0721875 * safezoneW";
            h = "0.022 * safezoneH";

            colorBackground[] = {0,0,0,1};
            colorActive[] = {0,0,0,1};
        };
        class bcs_settings_firemission_start_text: ITC_LAND_RscEdit {
            idc = 3207;
            text = "0001";
            x = QUOTE((0.479375 + POSXADJUST) * safezoneW + safezoneX);
            y = QUOTE((0.412 + POSYADJUST) * safezoneH + safezoneY);
            w = "0.0721875 * safezoneW";
            h = "0.022 * safezoneH";

            colorBackground[] = {0,0,0,1};
            colorActive[] = {0,0,0,1};
        };
        class bcs_settings_save_button: ITC_LAND_RscButton {
            idc = 3209;

            text = CSTRING(bcs_settings_save_button_Text);
            x = "0.659844 * safezoneW + safezoneX";
            y = "0.685 * safezoneH + safezoneY";
            w = "0.061875 * safezoneW";
            h = "0.022 * safezoneH";
            colorBackground[] = {0,0,0,0.9};
            colorActive[] = {0,0,0,0.9};

            action = "[""save""] call itc_land_tablet_fnc_pageInteract";
        };
    };
};
