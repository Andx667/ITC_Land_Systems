    // Overlay over another mod's gunner optics. Shows the same information as the IGS (ITC_Land_RscIGS_SPH):
    // keep the two in step when adding a readout (see veh_sights_fnc_runGunnerSight)
    #define ALTGRN {0.67451,1,0.6,1}
    #define ALT_X(ARG) QUOTE(ARG * (0.01875 * SafezoneH))
    #define ALT_Y(ARG) QUOTE(ARG * (0.025 * SafezoneH))
    #define ALT_BOX(NAME,IDC_BG,IDC_FRAME,Y,H) \
        class NAME##_background: RscText { \
            idc = IDC_BG; \
            x = ALT_X(0); \
            y = ALT_Y(Y); \
            w = ALT_X(15); \
            h = ALT_Y(H); \
            colorBackground[] = {0.1,0.1,0.1,0.75}; \
            style = 0; \
        }; \
        class NAME##_frame: RscFrame { \
            idc = IDC_FRAME; \
            x = ALT_X(0); \
            y = ALT_Y(Y); \
            w = ALT_X(15); \
            h = ALT_Y(H); \
            colorText[] = ALTGRN; \
        }
    #define ALT_LINE(X,Y,W) \
            x = ALT_X(X); \
            y = ALT_Y(Y); \
            w = ALT_X(W); \
            h = "0.022 * safezoneH"; \
            colorText[] = ALTGRN; \
            style = 0

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
                ALT_BOX(align,82010,82011,17,4.25);
                class align_header: RscText {
                    text = CSTRING(align_header_Text);
                    idc = 82012;
                    ALT_LINE(0,17.125,15);
                };
                class align_azi_header: RscText {
                    text = CSTRING(align_azi_header_Text);
                    idc = 82013;
                    ALT_LINE(0,17.85,7.5);
                };
                class align_azi: RscText {
                    idc = 82014;
                    text = "CA: 6400 MA: 6400";
                    ALT_LINE(0,18.65,7.5);
                };
                class align_quad_header: RscText {
                    text = CSTRING(align_quad_header_Text);
                    idc = 82015;
                    ALT_LINE(7.5,17.85,7.5);
                };
                class align_quad: RscText {
                    idc = 82016;
                    text = "CQ: 6400 MQ: 6400";
                    ALT_LINE(7.5,18.65,7.5);
                };
                // heading and laser range: the engine fills IDC 156 and 198, as in the IGS
                class align_heading_header: RscText {
                    text = CSTRING(align_heading_header_Text);
                    idc = 82024;
                    ALT_LINE(0,19.45,7.5);
                };
                class align_heading: RscText {
                    idc = 156;
                    text = "";
                    ALT_LINE(0,20.25,7.5);
                };
                class align_range_header: RscText {
                    text = CSTRING(align_range_header_Text);
                    idc = 82025;
                    ALT_LINE(7.5,19.45,7.5);
                };
                class align_range: RscText {
                    idc = 198;
                    text = "";
                    ALT_LINE(7.5,20.25,7.5);
                };

                ALT_BOX(loader,82017,82018,22.6,4.5);
                class ITC_Land_AutoLoader: RscText {
                    text = CSTRING(AutoLoader_Text);
                    idc = 82019;
                    ALT_LINE(0,22.725,15);
                };
                class ITC_Land_AutoLoaderStatus_text: RscText {
                    idc = 82020;
                    text = CSTRING(AutoLoaderStatus_text_Text);
                    ALT_LINE(0,23.525,15);
                };
                class ITC_Land_CAutoLoaderAmmo_text: RscText {
                    idc = 82021;
                    text = CSTRING(CAutoLoaderAmmo_text_Text);
                    ALT_LINE(0,24.325,15);
                };
                class ITC_Land_AutoLoaderFuze_text: RscText {
                    idc = 82022;
                    text = CSTRING(AutoLoaderFuze_text_Text);
                    ALT_LINE(0,25.125,15);
                };
                class ITC_Land_AutoLoaderGuidance_text: RscText {
                    idc = 82023;
                    text = CSTRING(AutoLoaderGuidance_text_Text);
                    ALT_LINE(0,25.925,15);
                };

                // FCI orders, hidden until itc_land_IGS_showOrders (placeholders, like the IGS panel)
                ALT_BOX(orders,82030,82031,28.45,5.3);
                class ITC_Land_Orders: RscText {
                    idc = 82032;
                    text = CSTRING(Orders_Text);
                    ALT_LINE(0,28.575,15);
                };
                class ITC_Land_OrdersCount: RscText {
                    idc = 82033;
                    text = "";
                    ALT_LINE(0,29.375,15);
                };
                class ITC_Land_OrdersLoad: RscText {
                    idc = 82034;
                    text = "";
                    ALT_LINE(0,30.175,15);
                };
                class ITC_Land_OrdersFuze: RscText {
                    idc = 82035;
                    text = "";
                    ALT_LINE(0,30.975,15);
                };
                class ITC_Land_OrdersGuided: RscText {
                    idc = 82036;
                    text = "";
                    ALT_LINE(0,31.775,15);
                };
                class ITC_Land_FCIalign: RscText {
                    idc = 82037;
                    text = "";
                    ALT_LINE(0,32.575,15);
                };
            };
        };
    };
