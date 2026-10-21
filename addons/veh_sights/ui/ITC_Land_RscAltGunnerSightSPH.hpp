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
                class align_background: RscText {
                    idc = 82010;
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "17 *       (0.025 * SafezoneH)";
                    w = "10.75 *        (0.01875 * SafezoneH)";
                    h = "2.65 *         (0.025 * SafezoneH)";
                    colorBackground[] = {0.1,0.1,0.1,0.75};
                    style = 0;
                };
                class align_frame: RscFrame {
                    idc = 82011;
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "17 *       (0.025 * SafezoneH)";
                    w = "10.75 *        (0.01875 * SafezoneH)";
                    h = "2.65 *         (0.025 * SafezoneH)";
                    colorText[] = {0.67451,1,0.6,1};
                    //style = 0xA0;                 
                };
                class align_header: RscText {
                    text = CSTRING(align_header_Text);
                    idc = 82012;
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "17.125 *       (0.025 * SafezoneH)";
                    w = "0.0721875 * safezoneW";
                    h = "0.022 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };
                class align_azi_header: RscText {
                    text = CSTRING(align_azi_header_Text);
                    idc = 82013;
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "17.85 *        (0.025 * SafezoneH)";
                    w = "0.0721875 * safezoneW";
                    h = "0.022 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };              
                class align_azi: RscText {
                    idc = 82014;
                    text = "CA: 6400 MA: 6400";
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "18.65 *        (0.025 * SafezoneH)";
                    w = "0.0721875 * safezoneW";
                    h = "0.022 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };
                class align_quad_header: RscText {
                    text = CSTRING(align_quad_header_Text);
                    idc = 82015;
                    x = "5 *        (0.01875 * SafezoneH)";
                    y = "17.85 *        (0.025 * SafezoneH)";
                    w = "0.0721875 * safezoneW";
                    h = "0.022 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };              
                class align_quad: RscText {
                    idc = 82016;
                    text = "CQ: 6400 MQ: 6400";
                    x = "5 *        (0.01875 * SafezoneH)";
                    y = "18.65 *        (0.025 * SafezoneH)";
                    w = "0.0721875 * safezoneW";
                    h = "0.022 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };


                
                class loader_background: RscText {
                    idc = 82017;                    
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "21 *       (0.025 * SafezoneH)";
                    w = "10.75 *        (0.01875 * SafezoneH)";
                    h = "4.5 *      (0.025 * SafezoneH)";
                    colorBackground[] = {0.1,0.1,0.1,0.75};
                    style = 0;                  
                };  
                class loader_frame: RscFrame {
                    idc = 82018;                        
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "21 *       (0.025 * SafezoneH)";
                    w = "10.75 *        (0.01875 * SafezoneH)";
                    h = "4.5 *      (0.025 * SafezoneH)";
                    colorText[] = {0.67451,1,0.6,1};
                    //style = 0xA0;                 
                };

                class ITC_Land_AutoLoader: RscText {
                    text = CSTRING(AutoLoader_Text);
                    idc = 82019;                    
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "21.125 *       (0.025 * SafezoneH)";
                    w = "0.108281 * safezoneW";
                    h = "0.022 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };
                class ITC_Land_AutoLoaderStatus_text: RscText {
                    idc = 82020;
                    text = CSTRING(AutoLoaderStatus_text_Text);
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "21.95 *        (0.025 * SafezoneH)";
                    w = "0.149531 * safezoneW";
                    h = "0.011 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };
                
                class ITC_Land_CAutoLoaderAmmo_text: RscText {
                    idc = 82021;
                    text = CSTRING(CAutoLoaderAmmo_text_Text);
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "22.65 *        (0.025 * SafezoneH)";
                    w = "0.149531 * safezoneW";
                    h = "0.022 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };              
                class ITC_Land_AutoLoaderFuze_text: RscText {
                    idc = 82022;
                    text = CSTRING(AutoLoaderFuze_text_Text);
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "23.45 *        (0.025 * SafezoneH)";
                    w = "0.149531 * safezoneW";
                    h = "0.022 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };
                class ITC_Land_AutoLoaderGuidance_text: RscText {
                    idc = 82023;
                    text = CSTRING(AutoLoaderGuidance_text_Text);
                    x = "0 *        (0.01875 * SafezoneH)";
                    y = "24.25 *        (0.025 * SafezoneH)";
                    w = "0.149531 * safezoneW";
                    h = "0.022 * safezoneH";
                    colorText[] = {0.67451,1,0.6,1};
                    style = 0;                  
                };                          
            };
        };
    };  
