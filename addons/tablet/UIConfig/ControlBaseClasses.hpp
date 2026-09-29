//VESTIGIAL: To be removed following retesting - Toadball

#define AIFMSGRN {172/255,255/255,153/255,1}

class RscControlsGroup;

class ITC_LAND_RscText {
    deletable = 0;
    fade = 0;
    access = 0;
    type = 0;
    idc = -1;
    colorBackground[] = {0,0,0,0};
    colorText[] = AIFMSGRN;
    text = "";
    fixedWidth = 0;
    x = 0;
    y = 0;
    h = 0.037;
    w = 0.3;
    style = 0;
    shadow = 1;
    colorShadow[] = {0,0,0,0.5};
    font = "RobotoCondensed";
    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    linespacing = 1;
    tooltipColorText[] = {1,1,1,1};
    tooltipColorBox[] = {1,1,1,1};
    tooltipColorShade[] ={0,0,0,0.65};
};
class ITC_LAND_RscEdit
{
    deletable = 0;
    fade = 0;
    access = 0;
    type = 2;
    x = 0;
    y = 0;
    h = 0.04;
    w = 0.2;
        colorBackground[] = {0,0,0,0};
        colorText[] = AIFMSGRN;
    colorDisabled[] ={1,1,1,0.25};
    colorSelection[] =
    {
        "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",
        "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",
        "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",
        1
    };
    autocomplete = "";
    text = "";
    size = 0.2;
    style = "0x00 + 0x40";
    font = "RobotoCondensed";
    shadow = 2;
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    canModify = 1;
        tooltipColorText[] = {1,1,1,1};
        tooltipColorBox[] = {1,1,1,1};
        tooltipColorShade[] ={0,0,0,0.65};
};
class ITC_LAND_RscStructuredText
{
    deletable = 0;
    fade = 0;
    access = 0;
    type = 13;
    idc = -1;
    style = 0;
        colorText[] = AIFMSGRN;
    class Attributes
    {
        font = "RobotoCondensed";
        color = "#acff99";
        colorLink = "#D09B43";
        align = "left";
        shadow = 1;
    };
    x = 0;
    y = 0;
    h = 0.035;
    w = 0.1;
    text = "";
    size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    shadow = 1;
};
class ITC_LAND_RscPicture {
    deletable = 0;
    fade = 0;
    access = 0;
    type = 0;
    idc = -1;
    style = 48;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "TahomaB";
    sizeEx = 0;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
    x = 0;
    y = 0;
    w = 0.2;
    h = 0.15;
    tooltipColorText[] = AIFMSGRN;
    tooltipColorBox[] = AIFMSGRN;
    tooltipColorShade[] = {0,0,0,0.65};
};
class ITC_LAND_RscTextBox {
    idc = -1;
    deletable = 0;
    fade = 0;
    access = 0;
    type = 2;
    x = 0;
    y = 0;
    h = 0.04;
    w = 0.2;
    colorBackground[] = {0,0,0,0};
    colorText[] = AIFMSGRN;
    colorDisabled[] = {1,1,1,0.25};
    colorSelection[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])",1};
    autocomplete = "";
    text = "";
    size = 0.2;
    style = "0x00 + 0x40";
    font = "RobotoCondensed";
    shadow = 2;
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    canModify = 1;
    tooltipColorText[] = AIFMSGRN;
    tooltipColorBox[] = AIFMSGRN;
    tooltipColorShade[] = {0,0,0,0.65};
};
class ITC_LAND_Workspace: RscControlsGroup {
    onLoad = "(_this # 0) ctrlShow false";
    x = "(0.344062 - 0.04675) * safezoneW + safezoneX";
    y = "0.225 * safezoneH + safezoneY";
    w = "0.622812 * safezoneW";
    h = "0.506 * safezoneH";
};
class ITC_LAND_ScrollBar {
        color[] = AIFMSGRN;
        colorActive[] = AIFMSGRN;
        colorDisabled[] = {1, 1, 1, 0.3};
        thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
        arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
        arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
        border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
        shadow = 0;
        scrollSpeed = 0.06;
        width = 0;
        height = 0;
        autoScrollEnabled = 0;
        autoScrollSpeed = -1;
        autoScrollDelay = 5;
        autoScrollRewind = 0;
    };
class ITC_LAND_RscListBox {
    deletable = 0;
    fade = 0;
    access = 0;
    type = 5;
    rowHeight = 0;
    colorText[] = AIFMSGRN;
    colorDisabled[] = {1, 1, 1, 0.25};
    colorScrollbar[] = AIFMSGRN;
    colorSelect[] = {0, 0, 0, 1};
    colorSelect2[] = {0, 0, 0, 1};
    colorSelectBackground[] = {0.95, 0.95, 0.95, 1};
    colorSelectBackground2[] = {1, 1, 1, 0.5};
    colorBackground[] = {0, 0, 0, 0.3};
    soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect", 0.09, 1};
    autoScrollSpeed = -1;
    autoScrollDelay = 5;
    autoScrollRewind = 0;
    arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
    arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
    colorPicture[] = {1, 1, 1, 1};
    colorPictureSelected[] = {1, 1, 1, 1};
    colorPictureDisabled[] = {1, 1, 1, 0.25};
    colorPictureRight[] = {1, 1, 1, 1};
    colorPictureRightSelected[] = {1, 1, 1, 1};
    colorPictureRightDisabled[] = {1, 1, 1, 0.25};
    colorTextRight[] = {1, 1, 1, 1};
    colorSelectRight[] = {0, 0, 0, 1};
    colorSelect2Right[] = {0, 0, 0, 1};
    tooltipColorText[] = AIFMSGRN;
    tooltipColorBox[] = AIFMSGRN;
    tooltipColorShade[] = {0, 0, 0, 0.65};
    class ListScrollBar: ITC_LAND_ScrollBar {
        color[] = AIFMSGRN;
        autoScrollEnabled = 1;
    };
    x = 0;
    y = 0;
    w = 0.3;
    h = 0.3;
    style = 16;
    font = "RobotoCondensed";
    sizeEx = "( ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    shadow = 0;
    colorShadow[] = {0, 0, 0, 0.5};
    period = 1.2;
    maxHistoryDelay = 1;
};

class ITC_LAND_RscComboBox {
    deletable = 0;
    fade = 0;
    access = 0;
    type = 4;
    colorSelect[] = {0,0,0,1};
    colorText[] = AIFMSGRN;
    colorBackground[] = {0,0,0,1};
    colorSelectBackground[] = AIFMSGRN;
    colorScrollbar[] = AIFMSGRN;
    colorDisabled[] = {1,1,1,0.25};
    colorPicture[] ={1,1,1,1};
    colorPictureSelected[] = AIFMSGRN;
    colorPictureDisabled[] = {1,1,1,0.25};
    colorPictureRight[] = {1,1,1,1};
    colorPictureRightSelected[] = {1,1,1,1};
    colorPictureRightDisabled[] = {1,1,1,0.25};
    colorTextRight[] = AIFMSGRN;
    colorSelectRight[] = {0,0,0,1};
    colorSelect2Right[] = {0,0,0,1};
    tooltipColorText[] = AIFMSGRN;
    tooltipColorBox[] = AIFMSGRN;
    tooltipColorShade[] = {0,0,0,0.65};
    soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1};
    soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1};
    soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1};
    maxHistoryDelay = 1;
    class ComboScrollBar {
        color[] = {1,1,1,1};
    };
    style = "0x10 + 0x200";
    font = "RobotoCondensed";
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    shadow = 0;
    x = 0;
    y = 0;
    w = 0.12;
    h = 0.035;
    arrowEmpty = QPATHTOF(UI\arrow_combo_ca.paa);
    arrowFull = QPATHTOF(UI\arrow_combo_active_ca.paa);
    wholeHeight = 0.45;
    colorActive[] = {1,0,0,1};
};

class ITC_LAND_RscButton {
    deletable = 0;
    fade = 0;
    access = 0;
    type = 1;
    text = "";
    colorText[] = AIFMSGRN;
    colorDisabled[] = {1,1,1,0.25};
    colorBackground[] = {0,0,0,0.5};
    colorBackgroundDisabled[] = {0,0,0,0.5};
    colorBackgroundActive[] = {0.2,0.2,0.2,1};
    colorFocused[] = {0,0,0,0.5};
    colorShadow[] ={0,0,0,0};
    colorBorder[] = AIFMSGRN;
    soundEnter[] ={"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
    soundPush[] ={"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
    soundClick[] ={"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
    soundEscape[] ={"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
    idc = -1;
    style = 2;
    x = 0;
    y = 0;
    w = 0.095589;
    h = 0.039216;
    shadow = 2;
    font = "RobotoCondensed";
    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
    borderSize = 0;
};
