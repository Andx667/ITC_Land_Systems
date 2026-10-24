// An app of the HTML tablet: webView builds its view ([vehicle, app] call, see tablet_fnc_webState),
// webAction runs the page's actions ([vehicle, app, action, value] call, see tablet_fnc_webReceive),
// webPages are its sidebar pages, webStartPage the page it starts on (or what webStartFunction returns).
class itc_land {
    class apps {
        class spg {
            displayName = CSTRING(spg_DisplayName);
            interfaces = "ITC Self Propelled Gun";
            sharedApp = "artillery";
            title = "SPG APP";
            subtitle = "SP Artillery";
            sidebar2 = "INS / DATA";
            webView = QFUNC(webViewArtillery);
            webAction = QFUNC(webActionArtillery);
            webPages[] = {"fcs", "status"};
            webStartPage = "fcs";
        };
        class bcs {
            displayName = CSTRING(bcs_DisplayName);
            interfaces = "-";
            webView = QFUNC(webViewBcs);
            webAction = QFUNC(webActionBcs);
            webPages[] = {"settings", "setup", "locStores"};
            webStartPage = "settings";
            // a handed-over target's fire mission starts on its engagement
            webStartFunction = QFUNC(bcsInit);
        };
        class cbr {
            displayName = CSTRING(cbr_DisplayName);
            interfaces = "Datalink";
            webView = QFUNC(webViewCbr);
            webAction = QFUNC(webActionCbr);
            webPages[] = {"map", "data"};
            webStartPage = "map";
        };
        class missile {
            displayName = CSTRING(missile_DisplayName);
            interfaces = "ITC Self Propelled Gun";
            sharedApp = "artillery";
            title = "MLRS APP";
            subtitle = "MLRS";
            sidebar2 = "STATUS";
            webView = QFUNC(webViewArtillery);
            webAction = QFUNC(webActionArtillery);
            webPages[] = {"fcs", "status"};
            webStartPage = "fcs";
        };
    };
};
