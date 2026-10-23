// Shared layout of the boxed sight readouts (overlay, basic and MLRS sights). Units are those of
// the sights' control groups: 0.01875 * SafezoneH across, 0.025 * SafezoneH down.
#define SIGHT_GREEN {0.67451,1,0.6,1}
#define SIGHT_RED {0.706,0.0745,0.0196,1}
#define SIGHT_X(ARG) QUOTE(ARG * (0.01875 * SafezoneH))
#define SIGHT_Y(ARG) QUOTE(ARG * (0.025 * SafezoneH))
#define SIGHT_BOX(NAME,IDC_BG,IDC_FRAME,X,Y,W,H,COLOR) \
    class NAME##_background: RscText { \
        idc = IDC_BG; \
        x = SIGHT_X(X); \
        y = SIGHT_Y(Y); \
        w = SIGHT_X(W); \
        h = SIGHT_Y(H); \
        colorBackground[] = {0.1,0.1,0.1,0.75}; \
        style = 0; \
    }; \
    class NAME##_frame: RscFrame { \
        idc = IDC_FRAME; \
        x = SIGHT_X(X); \
        y = SIGHT_Y(Y); \
        w = SIGHT_X(W); \
        h = SIGHT_Y(H); \
        colorText[] = COLOR; \
    }
#define SIGHT_LINE(X,Y,W,COLOR) \
        x = SIGHT_X(X); \
        y = SIGHT_Y(Y); \
        w = SIGHT_X(W); \
        h = "0.022 * safezoneH"; \
        colorText[] = COLOR; \
        style = 0

// FCI ORDERS: the FDC's fire orders (veh_sights_fnc_getFireOrdersText), shown by runGunnerSight while
// the gun has them; the IDCs match SIGHT_ORDERS_LAYOUT in script_component.hpp
#define SIGHT_ORDERS_LINE(NAME,IDC,X,Y,COLOR) \
    class NAME: RscText { \
        idc = IDC; \
        text = ""; \
        SIGHT_LINE(X,Y,15,COLOR); \
    }
#define SIGHT_ORDERS_PANEL(X,Y,COLOR) \
    SIGHT_BOX(orders,82030,82031,X,Y,15,5.3,COLOR); \
    SIGHT_ORDERS_LINE(ITC_Land_Orders,82032,X,(Y + 0.125),COLOR); \
    SIGHT_ORDERS_LINE(ITC_Land_OrdersCount,82033,X,(Y + 0.925),COLOR); \
    SIGHT_ORDERS_LINE(ITC_Land_OrdersLoad,82034,X,(Y + 1.725),COLOR); \
    SIGHT_ORDERS_LINE(ITC_Land_OrdersFuze,82035,X,(Y + 2.525),COLOR); \
    SIGHT_ORDERS_LINE(ITC_Land_OrdersGuided,82036,X,(Y + 3.325),COLOR); \
    SIGHT_ORDERS_LINE(ITC_Land_FCIalign,82037,X,(Y + 4.125),COLOR)
