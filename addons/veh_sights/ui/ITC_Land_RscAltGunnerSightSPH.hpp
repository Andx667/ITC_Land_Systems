    // Overlay over another mod's gunner optics. Shows the same information as the IGS (ITC_Land_RscIGS_SPH):
    // keep the two in step when adding a readout (see veh_sights_fnc_runGunnerSight); macros in ITC_Land_sightMacros.hpp
    class ITC_Land_RscAltGunnerSightSPH {
        onLoad = "uiNamespace setVariable ['ITC_Land_RscAltGunnerSightSPH', _this select 0]; ['itc_land_onLoad_RscAltGunnerSightSPH', []] call CBA_fnc_localEvent;";
        idd = 513;
        controls[] = {"ITC_Land_IGUI_elements_group"};
        class ITC_Land_IGUI_elements_group: RscControlsGroup {
            idc = 82001;
            x = "-5 *       (0.01875 * SafezoneH) +         (SafezoneX + ((SafezoneW - SafezoneH) / 2))";
            y = "0 *        (0.025 * SafezoneH) +       (SafezoneY)";
            w = "55 *       (0.01875 * SafezoneH)";
            h = "40 *       (0.025 * SafezoneH)";
            class controls {
                SIGHT_BOX(align,82010,82011,0,17,15,4.25,SIGHT_GREEN);
                class align_header: RscText {
                    text = CSTRING(align_header_Text);
                    idc = 82012;
                    SIGHT_LINE(0,17.125,15,SIGHT_GREEN);
                };
                class align_azi_header: RscText {
                    text = CSTRING(align_azi_header_Text);
                    idc = 82013;
                    SIGHT_LINE(0,17.85,7.5,SIGHT_GREEN);
                };
                class align_azi: RscText {
                    idc = 82014;
                    text = "CA: 6400 MA: 6400";
                    SIGHT_LINE(0,18.65,7.5,SIGHT_GREEN);
                };
                class align_quad_header: RscText {
                    text = CSTRING(align_quad_header_Text);
                    idc = 82015;
                    SIGHT_LINE(7.5,17.85,7.5,SIGHT_GREEN);
                };
                class align_quad: RscText {
                    idc = 82016;
                    text = "CQ: 6400 MQ: 6400";
                    SIGHT_LINE(7.5,18.65,7.5,SIGHT_GREEN);
                };
                // heading and laser range: the engine fills IDC 156 and 198, as in the IGS
                class align_heading_header: RscText {
                    text = CSTRING(align_heading_header_Text);
                    idc = 82024;
                    SIGHT_LINE(0,19.45,7.5,SIGHT_GREEN);
                };
                class align_heading: RscText {
                    idc = 156;
                    text = "";
                    SIGHT_LINE(0,20.25,7.5,SIGHT_GREEN);
                };
                class align_range_header: RscText {
                    text = CSTRING(align_range_header_Text);
                    idc = 82025;
                    SIGHT_LINE(7.5,19.45,7.5,SIGHT_GREEN);
                };
                class align_range: RscText {
                    idc = 198;
                    text = "";
                    SIGHT_LINE(7.5,20.25,7.5,SIGHT_GREEN);
                };

                SIGHT_BOX(loader,82017,82018,0,22.6,15,4.5,SIGHT_GREEN);
                class ITC_Land_AutoLoader: RscText {
                    text = CSTRING(AutoLoader_Text);
                    idc = 82019;
                    SIGHT_LINE(0,22.725,15,SIGHT_GREEN);
                };
                class ITC_Land_AutoLoaderStatus_text: RscText {
                    idc = 82020;
                    text = CSTRING(AutoLoaderStatus_text_Text);
                    SIGHT_LINE(0,23.525,15,SIGHT_GREEN);
                };
                class ITC_Land_CAutoLoaderAmmo_text: RscText {
                    idc = 82021;
                    text = CSTRING(CAutoLoaderAmmo_text_Text);
                    SIGHT_LINE(0,24.325,15,SIGHT_GREEN);
                };
                class ITC_Land_AutoLoaderFuze_text: RscText {
                    idc = 82022;
                    text = CSTRING(AutoLoaderFuze_text_Text);
                    SIGHT_LINE(0,25.125,15,SIGHT_GREEN);
                };
                class ITC_Land_AutoLoaderGuidance_text: RscText {
                    idc = 82023;
                    text = CSTRING(AutoLoaderGuidance_text_Text);
                    SIGHT_LINE(0,25.925,15,SIGHT_GREEN);
                };

                // FCI orders, shown while the gun has the FDC's fire orders
                SIGHT_ORDERS_PANEL(0,28.45,SIGHT_GREEN);
            };
        };
    };
