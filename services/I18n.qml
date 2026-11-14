pragma Singleton
import QtQuick
import Quickshell

// I18n.qml — translations for the shell UI.
//
// English, Simplified Chinese and Traditional Chinese are bundled.  Bindings
// call I18n.t("key") and re-evaluate automatically when the language changes.
QtObject {
    id: root

    readonly property var languages: ["auto", "en", "zh_CN", "zh_TW"]

    readonly property string detected: {
        var l = (Quickshell.env("LC_ALL") || Quickshell.env("LC_MESSAGES") || Quickshell.env("LANG") || "").toLowerCase();
        if (l.indexOf("zh_cn") >= 0 || l.indexOf("zh_hans") >= 0 || l.indexOf("zh_sg") >= 0)
            return "zh_CN";
        if (l.indexOf("zh") >= 0)
            return "zh_TW";
        return "en";
    }

    readonly property string lang: {
        var configured = Settings.get("language", "auto");
        return configured === "auto" ? root.detected : configured;
    }

    readonly property string languageLabel: root.lang === "zh_CN" ? "简体中文"
        : (root.lang === "zh_TW" ? "繁體中文" : "English")

    function t(key) {
        var table = dict[root.lang] || dict.en;
        var value = table ? table[key] : undefined;
        if (value === undefined)
            value = dict.en[key];
        if (value === undefined)
            value = dict.zh_CN[key];
        return value === undefined ? key : value;
    }

    readonly property var dict: ({
        en: {
            "common.on": "ON", "common.off": "OFF", "common.close": "CLOSE",
            "common.enabled": "ENABLED", "common.disabled": "DISABLED",
            "common.reset": "RESET DEFAULTS", "common.auto": "AUTO", "common.none": "NONE",
            "pos.top": "TOP", "pos.bottom": "BOTTOM", "pos.left": "LEFT", "pos.right": "RIGHT",

            "bar.launcher": "INVENTORY", "bar.power": "POWER", "bar.settings": "SETTINGS",
            "bar.volume": "VOL", "bar.network": "NET", "bar.battery": "BAT",
            "bar.day": "DAY",

            "launcher.title": "INVENTORY", "launcher.search": "Search items…",
            "launcher.hint": "TYPE TO SEARCH   ·   ENTER = LAUNCH   ·   ESC = CLOSE",
            "launcher.count": "ITEMS",

            "control.title": "OPTIONS", "control.sound": "SOUND", "control.brightness": "BRIGHT",
            "control.wifi": "WIFI", "control.bluetooth": "BT", "control.battery": "BAT",
            "control.nothingPlaying": "NOTHING PLAYING", "control.prev": "PREV",
            "control.play": "PLAY", "control.pause": "PAUSE", "control.next": "NEXT",
            "control.cpu": "CPU", "control.ram": "RAM", "control.up": "UP",
            "control.lock": "LOCK", "control.sleep": "SLEEP", "control.reboot": "REBOOT",
            "control.off": "OFF",

            "power.title": "MC-SHELL", "power.subtitle": "SELECT WORLD ACTION",
            "power.lock": "RETURN TO GAME", "power.sleep": "SAVE & QUIT TO SLEEP",
            "power.logout": "LEAVE SESSION", "power.reboot": "RESPAWN (REBOOT)",
            "power.off": "QUIT TO DESKTOP (POWER OFF)", "power.cancel": "BACK TO GAME",
            "power.hint": "CLICK AN ACTION   ·   ESC = CANCEL",

            "settings.title": "SETTINGS",
            "settings.tab.general": "GENERAL", "settings.tab.wallpaper": "WALLPAPER",
            "settings.tab.bar": "BAR", "settings.tab.theme": "THEME", "settings.tab.dock": "DOCK",
            "settings.tab.widgets": "WIDGETS", "settings.tab.sidebars": "SIDEBARS",

            "settings.general.language": "LANGUAGE", "settings.general.languageHint": "AUTO follows your system locale",
            "settings.general.shortcuts": "SHORTCUTS",
            "settings.general.hint": "Bind these in your compositor config:",
            "settings.language.auto": "AUTO",

            "settings.wallpaper.enabled": "ENABLE WALLPAPER LAYER",
            "settings.wallpaper.path": "IMAGE PATH", "settings.wallpaper.pathHint": "/home/you/Pictures/wall.png",
            "settings.wallpaper.color": "FALLBACK COLOUR", "settings.wallpaper.fill": "FILL MODE",
            "settings.wallpaper.note": "MC-shell draws its own background layer, so this works on Hyprland and niri alike. Turn it off if you use hyprpaper/swaybg.",

            "settings.bar.visible": "SHOW BAR", "settings.bar.position": "BAR POSITION",
            "settings.bar.thickness": "BAR THICKNESS", "settings.bar.stats": "SHOW CPU/RAM HUD",
            "settings.bar.tray": "SHOW SYSTEM TRAY", "settings.bar.title": "SHOW WINDOW TITLE",
            "settings.bar.clock": "SHOW CLOCK", "settings.bar.note": "Position applies immediately; the bar reserves its edge.",

            "settings.theme.accent": "ACCENT", "settings.theme.gold": "HIGHLIGHT",
            "settings.theme.scale": "UI SCALE",
            "settings.theme.texture": "BAR TEXTURE", "settings.theme.panelTexture": "PANEL TEXTURE",
            "settings.theme.note": "Textures are generated pixel art; pick the block that fits.",

            "settings.dock.visible": "SHOW DOCK", "settings.dock.position": "DOCK POSITION",
            "settings.dock.autohide": "AUTO HIDE", "settings.dock.iconSize": "ICON SIZE",
            "settings.dock.pinned": "PINNED APPS", "settings.dock.pinnedHint": "One desktop-file id per line",

            "settings.widgets.title": "DESKTOP WIDGETS",
            "settings.widgets.hint": "Drag widgets on the desktop to move them.",
            "settings.sidebars.left": "LEFT BASKET", "settings.sidebars.right": "RIGHT BASKET",
            "settings.sidebars.enabled": "SHOW", "settings.sidebars.width": "WIDTH",
            "settings.sidebars.widgets": "WIDGETS",
            "settings.sidebars.note": "Baskets dock to the screen edges and host widgets.",

            "widget.clock": "CLOCK", "widget.weather": "WEATHER", "widget.visualizer": "MUSIC",
            "widget.calendar": "CALENDAR", "widget.stats": "SYSTEM", "widget.music": "NOW PLAYING",
            "widget.weather.city": "CITY", "widget.weather.cityHint": "empty = auto",
            "widget.visualizer.bars": "BARS",

            "osd.volume": "VOLUME", "osd.brightness": "BRIGHTNESS",
            "sidebar.left": "LEFT BASKET", "sidebar.right": "RIGHT BASKET",
            "weather.loading": "SCANNING SKY…", "weather.unavailable": "NO SIGNAL",
            "dock.empty": "NO APPS"
        },
        zh_CN: {
            "common.on": "开", "common.off": "关", "common.close": "关闭",
            "common.enabled": "已启用", "common.disabled": "已禁用",
            "common.reset": "恢复默认", "common.auto": "自动", "common.none": "无",
            "pos.top": "顶部", "pos.bottom": "底部", "pos.left": "左侧", "pos.right": "右侧",

            "bar.launcher": "物品栏", "bar.power": "电源", "bar.settings": "设置",
            "bar.volume": "音量", "bar.network": "网络", "bar.battery": "电量",
            "bar.day": "第",

            "launcher.title": "物品栏", "launcher.search": "搜索物品…",
            "launcher.hint": "输入搜索   ·   回车 = 启动   ·   ESC = 关闭",
            "launcher.count": "个物品",

            "control.title": "选项", "control.sound": "声音", "control.brightness": "亮度",
            "control.wifi": "无线", "control.bluetooth": "蓝牙", "control.battery": "电量",
            "control.nothingPlaying": "没有正在播放的内容", "control.prev": "上一首",
            "control.play": "播放", "control.pause": "暂停", "control.next": "下一首",
            "control.cpu": "处理器", "control.ram": "内存", "control.up": "已运行",
            "control.lock": "锁定", "control.sleep": "睡眠", "control.reboot": "重启",
            "control.off": "关机",

            "power.title": "MC-SHELL", "power.subtitle": "选择一个世界操作",
            "power.lock": "返回游戏（锁定）", "power.sleep": "保存并退出（睡眠）",
            "power.logout": "离开会话", "power.reboot": "重新出生（重启）",
            "power.off": "退出到桌面（关机）", "power.cancel": "返回游戏（取消）",
            "power.hint": "点击操作   ·   ESC = 取消",

            "settings.title": "设置",
            "settings.tab.general": "通用", "settings.tab.wallpaper": "壁纸",
            "settings.tab.bar": "状态栏", "settings.tab.theme": "主题", "settings.tab.dock": "应用篮",
            "settings.tab.widgets": "桌面组件", "settings.tab.sidebars": "侧边篮",

            "settings.general.language": "语言", "settings.general.languageHint": "自动：跟随系统语言环境",
            "settings.general.shortcuts": "快捷键",
            "settings.general.hint": "在合成器配置里绑定：",
            "settings.language.auto": "自动",

            "settings.wallpaper.enabled": "启用壁纸图层",
            "settings.wallpaper.path": "图片路径", "settings.wallpaper.pathHint": "/home/你/图片/wall.png",
            "settings.wallpaper.color": "备用底色", "settings.wallpaper.fill": "填充方式",
            "settings.wallpaper.note": "MC-shell 自己绘制背景层，Hyprland 与 niri 都可用。若已用 hyprpaper/swaybg 可关闭。",

            "settings.bar.visible": "显示状态栏", "settings.bar.position": "状态栏位置",
            "settings.bar.thickness": "状态栏厚度", "settings.bar.stats": "显示 CPU/内存 HUD",
            "settings.bar.tray": "显示系统托盘", "settings.bar.title": "显示窗口标题",
            "settings.bar.clock": "显示时钟", "settings.bar.note": "位置立即生效，状态栏会占用对应屏幕边缘。",

            "settings.theme.accent": "强调色", "settings.theme.gold": "高亮色",
            "settings.theme.scale": "界面缩放",
            "settings.theme.texture": "状态栏材质", "settings.theme.panelTexture": "面板材质",
            "settings.theme.note": "贴图均为程序生成的像素画，挑一个喜欢的方块材质。",

            "settings.dock.visible": "显示应用篮", "settings.dock.position": "应用篮位置",
            "settings.dock.autohide": "自动隐藏", "settings.dock.iconSize": "图标大小",
            "settings.dock.pinned": "固定应用", "settings.dock.pinnedHint": "每行一个 desktop 文件名",

            "settings.widgets.title": "桌面组件",
            "settings.widgets.hint": "在桌面上拖动组件即可移动位置。",
            "settings.sidebars.left": "左侧边篮", "settings.sidebars.right": "右侧边篮",
            "settings.sidebars.enabled": "显示", "settings.sidebars.width": "宽度",
            "settings.sidebars.widgets": "组件",
            "settings.sidebars.note": "侧边篮贴靠屏幕左右边缘，用来承载组件。",

            "widget.clock": "时钟", "widget.weather": "天气", "widget.visualizer": "音乐",
            "widget.calendar": "日历", "widget.stats": "系统", "widget.music": "正在播放",
            "widget.weather.city": "城市", "widget.weather.cityHint": "留空 = 自动",
            "widget.visualizer.bars": "柱数",

            "osd.volume": "音量", "osd.brightness": "亮度",
            "sidebar.left": "左侧边篮", "sidebar.right": "右侧边篮",
            "weather.loading": "正在观测天空…", "weather.unavailable": "无信号",
            "dock.empty": "没有应用"
        },
        zh_TW: {
            "common.on": "開", "common.off": "關", "common.close": "關閉",
            "common.enabled": "已啟用", "common.disabled": "已停用",
            "common.reset": "恢復預設", "common.auto": "自動", "common.none": "無",
            "pos.top": "頂部", "pos.bottom": "底部", "pos.left": "左側", "pos.right": "右側",

            "bar.launcher": "物品欄", "bar.power": "電源", "bar.settings": "設定",
            "bar.volume": "音量", "bar.network": "網路", "bar.battery": "電量",
            "bar.day": "第",

            "launcher.title": "物品欄", "launcher.search": "搜尋物品…",
            "launcher.hint": "輸入搜尋   ·    Enter = 啟動   ·   ESC = 關閉",
            "launcher.count": "個物品",

            "control.title": "選項", "control.sound": "聲音", "control.brightness": "亮度",
            "control.wifi": "無線", "control.bluetooth": "藍牙", "control.battery": "電量",
            "control.nothingPlaying": "沒有正在播放的內容", "control.prev": "上一首",
            "control.play": "播放", "control.pause": "暫停", "control.next": "下一首",
            "control.cpu": "處理器", "control.ram": "記憶體", "control.up": "已運行",
            "control.lock": "鎖定", "control.sleep": "睡眠", "control.reboot": "重啟",
            "control.off": "關機",

            "power.title": "MC-SHELL", "power.subtitle": "選擇一個世界操作",
            "power.lock": "返回遊戲（鎖定）", "power.sleep": "儲存並退出（睡眠）",
            "power.logout": "離開工作階段", "power.reboot": "重新出生（重啟）",
            "power.off": "退出到桌面（關機）", "power.cancel": "返回遊戲（取消）",
            "power.hint": "點擊操作   ·   ESC = 取消",

            "settings.title": "設定",
            "settings.tab.general": "一般", "settings.tab.wallpaper": "桌布",
            "settings.tab.bar": "狀態列", "settings.tab.theme": "主題", "settings.tab.dock": "應用籃",
            "settings.tab.widgets": "桌面元件", "settings.tab.sidebars": "側邊籃",

            "settings.general.language": "語言", "settings.general.languageHint": "自動：跟隨系統語言環境",
            "settings.general.shortcuts": "快速鍵",
            "settings.general.hint": "在合成器設定裡綁定：",
            "settings.language.auto": "自動",

            "settings.wallpaper.enabled": "啟用桌布圖層",
            "settings.wallpaper.path": "圖片路徑", "settings.wallpaper.pathHint": "/home/你/圖片/wall.png",
            "settings.wallpaper.color": "備用底色", "settings.wallpaper.fill": "填滿方式",
            "settings.wallpaper.note": "MC-shell 自己繪製背景層，Hyprland 與 niri 都可用。若已用 hyprpaper/swaybg 可關閉。",

            "settings.bar.visible": "顯示狀態列", "settings.bar.position": "狀態列位置",
            "settings.bar.thickness": "狀態列厚度", "settings.bar.stats": "顯示 CPU/記憶體 HUD",
            "settings.bar.tray": "顯示系統匣", "settings.bar.title": "顯示視窗標題",
            "settings.bar.clock": "顯示時鐘", "settings.bar.note": "位置立即生效，狀態列會佔用對應螢幕邊緣。",

            "settings.theme.accent": "強調色", "settings.theme.gold": "高亮色",
            "settings.theme.scale": "介面縮放",
            "settings.theme.texture": "狀態列材質", "settings.theme.panelTexture": "面板材質",
            "settings.theme.note": "貼圖皆為程式生成的像素畫，挑一個喜歡的方塊材質。",

            "settings.dock.visible": "顯示應用籃", "settings.dock.position": "應用籃位置",
            "settings.dock.autohide": "自動隱藏", "settings.dock.iconSize": "圖示大小",
            "settings.dock.pinned": "固定應用程式", "settings.dock.pinnedHint": "每行一個 desktop 檔名",

            "settings.widgets.title": "桌面元件",
            "settings.widgets.hint": "在桌面上拖曳元件即可移動位置。",
            "settings.sidebars.left": "左側邊籃", "settings.sidebars.right": "右側邊籃",
            "settings.sidebars.enabled": "顯示", "settings.sidebars.width": "寬度",
            "settings.sidebars.widgets": "元件",
            "settings.sidebars.note": "側邊籃貼靠螢幕左右邊緣，用來承載元件。",

            "widget.clock": "時鐘", "widget.weather": "天氣", "widget.visualizer": "音樂",
            "widget.calendar": "日曆", "widget.stats": "系統", "widget.music": "正在播放",
            "widget.weather.city": "城市", "widget.weather.cityHint": "留空 = 自動",
            "widget.visualizer.bars": "柱數",

            "osd.volume": "音量", "osd.brightness": "亮度",
            "sidebar.left": "左側邊籃", "sidebar.right": "右側邊籃",
            "weather.loading": "正在觀測天空…", "weather.unavailable": "無訊號",
            "dock.empty": "沒有應用程式"
        }
    })
}
