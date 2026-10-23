// The tablet in HTML (tablet_fnc_webOpen): the classic tablet's frame pictures (day and night,
// the night one faded in as it gets dark) with a CT_WEBBROWSER control (Arma 3 2.20) of their
// size over them; its page is transparent but for the screen in the frame's glass and the APP
// keys. The frame is native so it shows at once, while the browser starts. Native controls draw
// over the browser: the COBRA map, placed over the page's map slot by tablet_fnc_webPlaceMap, and
// a close button that works also when the page cannot reach the game. The page is loaded by
// script after the event handlers are on, so the control has no url.
class itc_land_tablet_web {
    idd = 32570;
    movingEnable = 0;
    controlsBackground[] = {"screen_image", "screen_image_night"};
    controls[] = {"browser", "map", "closeButton"};

    class screen_image: ITC_LAND_RscPicture {
        idc = 32575;
        text = QPATHTOF(UI\screen.paa);
        x = "0.5-((0.64*SafeZoneW)/2)";
        y = "0.5-((1.03*SafeZoneW)/2)";
        w = "0.64*SafeZoneW";
        h = "0.86*SafeZoneW";
        style = ST_PICTURE;
    };
    class screen_image_night: screen_image {
        idc = 32576;
        text = QPATHTOF(UI\screen-night.paa);
    };

    class browser {
        type = 106; // CT_WEBBROWSER
        idc = 32571;
        style = 0;
        // read for every control type: without them the RPT warns on opening (No entry ... colorBackground)
        colorBackground[] = {0, 0, 0, 0};
        colorText[] = {1, 1, 1, 1};
        font = "RobotoCondensed";
        sizeEx = 0.03;
        text = "";
        x = "0.5-((0.64*SafeZoneW)/2)";
        y = "0.5-((1.03*SafeZoneW)/2)";
        w = "0.64*SafeZoneW";
        h = "0.86*SafeZoneW";
    };
    // hidden until the page reports its slot; created with a real size, as a map control of no size may not draw
    class map: RscMapControl {
        idc = 32574;
        x = "0.5 - 0.2*SafeZoneW";
        y = "0.5 - 0.2*SafeZoneW";
        w = "0.4*SafeZoneW";
        h = "0.3*SafeZoneW";
    };
    // over the frame, right above the screen's top right corner
    class closeButton: ITC_LAND_RscButton {
        idc = 32573;
        text = "X";
        x = "0.5 + 0.2542*SafeZoneW";
        y = "0.5 - 0.2585*SafeZoneW";
        w = "0.02*SafeZoneW";
        h = "0.02*SafeZoneW";
        action = "closeDialog 0";
    };
};
