class page_bcs_firemission_solution:ITC_LAND_Workspace {
    idc = 13506;
    class Controls {
        class itc_land_solution_list: ITC_LAND_RscListBox {
            idc = 8500;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.269 * safezoneH + safezoneY";
            w = "0.345469 * safezoneW";
            h = "0.176 * safezoneH";
        };
        class itc_land_solution_ordinate_label: ITC_LAND_RscText {
            idc = 8004;
            tooltip = CSTRING(solution_ordinate_Tooltip);
            text = CSTRING(solution_ordinate_label_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.467 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_solution_angle_label: ITC_LAND_RscText {
            idc = 8006;
            tooltip = CSTRING(solution_angle_Tooltip);
            text = CSTRING(solution_angle_label_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.489 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_solution_distance_label: ITC_LAND_RscText {
            idc = 8017;
            tooltip = CSTRING(solution_distance_Tooltip);
            text = CSTRING(solution_distance_label_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.511 * safezoneH + safezoneY";
            w = "0.0825 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_firemission_back: ITC_LAND_RscButton {
            idc = 8604;
            text = CSTRING(firemission_back_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.555 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""back""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_solution_shot: ITC_LAND_RscButton {
            idc = 8600;
            text = CSTRING(solution_shot_Text); //--- ToDo: Localize;
            x = "0.426562 * safezoneW + safezoneX";
            y = "0.555 * safezoneH + safezoneY";
            w = "0.0567187 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""shot""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_solution_adj: ITC_LAND_RscButton {
            idc = 8601;
            text = CSTRING(solution_adj_Text); //--- ToDo: Localize;
            x = "0.578906 * safezoneW + safezoneX";
            y = "0.555 * safezoneH + safezoneY";
            w = "0.061875 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""adjust""] call itc_land_tablet_fnc_pageInteract";
        };
        // send the firing data over the datalink to the linked guns' sights
        class itc_land_solution_send_adj: ITC_LAND_RscButton {
            idc = 8605;
            tooltip = CSTRING(solution_send_adj_Tooltip);
            text = CSTRING(solution_send_adj_Text);
            x = "0.649531 * safezoneW + safezoneX";
            y = "0.467 * safezoneH + safezoneY";
            w = "0.061875 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""sendadj""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_solution_send_ffe: ITC_LAND_RscButton {
            idc = 8606;
            tooltip = CSTRING(solution_send_ffe_Tooltip);
            text = CSTRING(solution_send_ffe_Text);
            x = "0.649531 * safezoneW + safezoneX";
            y = "0.555 * safezoneH + safezoneY";
            w = "0.061875 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""sendffe""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_solution_solup: ITC_LAND_RscButton {
            idc = 8040;
            text = CSTRING(solution_solup_Text); //--- ToDo: Localize;
            x = "0.6098435 * safezoneW + safezoneX";
            y = "0.467 * safezoneH + safezoneY";
            w = "0.0309375 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""solup""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_solution_soldn: ITC_LAND_RscButton {
            idc = 8041;
            text = CSTRING(solution_soldn_Text); //--- ToDo: Localize;
            x = "0.578906 * safezoneW + safezoneX";
            y = "0.467 * safezoneH + safezoneY";
            w = "0.0309375 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""soldn""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_solution_ordinate_text: ITC_LAND_RscText {
            idc = 8018;
            tooltip = CSTRING(solution_ordinate_Tooltip);
            text = ""; //--- ToDo: Localize;
            x = "0.448438 * safezoneW + safezoneX";
            y = "0.467 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_solution_angle_text: ITC_LAND_RscText {
            idc = 8019;
            tooltip = CSTRING(solution_angle_Tooltip);
            text = ""; //--- ToDo: Localize;
            x = "0.448438 * safezoneW + safezoneX";
            y = "0.489 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_solution_distance_text: ITC_LAND_RscText {
            idc = 8020;
            tooltip = CSTRING(solution_distance_Tooltip);
            text = ""; //--- ToDo: Localize;
            x = "0.448438 * safezoneW + safezoneX";
            y = "0.511 * safezoneH + safezoneY";
            w = "0.0515625 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_solution_shot_text: ITC_LAND_RscText {
            idc = 8021;
            tooltip = CSTRING(solution_shot_Tooltip);
            text = "----"; //--- ToDo: Localize;
            x = "0.4932807 * safezoneW + safezoneX";
            y = "0.555 * safezoneH + safezoneY";
            w = "0.0567187 * safezoneW";
            h = "0.033 * safezoneH";
        };
        class itc_land_solution_solutionCount_text: ITC_LAND_RscText {
            idc = 8022;
            tooltip = CSTRING(solution_solutionCount_Tooltip);
            text = CSTRING(solution_solutionCount_text_Text); //--- ToDo: Localize;
            x = "0.365937 * safezoneW + safezoneX";
            y = "0.247 * safezoneH + safezoneY";
            w = "0.345469 * safezoneW";
            h = "0.022 * safezoneH";
        };
        class itc_land_solution_eom: ITC_LAND_RscButton {
            idc = 8602;
            text = CSTRING(solution_eom_Text); //--- ToDo: Localize;
            x = "0.578906 * safezoneW + safezoneX";
            y = "0.62 * safezoneH + safezoneY";
            w = "0.061875 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""eom""] call itc_land_tablet_fnc_pageInteract";
        };
        class itc_land_solution_eom_save: ITC_LAND_RscButton {
            idc = 8603;
            text = CSTRING(solution_eom_save_Text); //--- ToDo: Localize;
            x = "0.649531 * safezoneW + safezoneX";
            y = "0.62 * safezoneH + safezoneY";
            w = "0.061875 * safezoneW";
            h = "0.044 * safezoneH";
            action = "[""eomsave""] call itc_land_tablet_fnc_pageInteract";
        };
    };
};
