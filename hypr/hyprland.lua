
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@74",  position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-1",     mode = "2560x1440@240", position = "2560x0", scale = 1 })
hl.monitor({ output = "DVI-D-1",  mode = "2560x1440@74",  position = "5120x0", scale = 1 })

local terminal       = "kitty"
local fileManager    = "dolphin"
local pMenu          = "rofi -show drun"
local wMenu          = "rofi -show window"
local browser        = "zen"
local discord        = "discord --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland --disable-gpu-sandbox"
local swaync         = "swaync-client -t"
local screenshotter  = "/home/ttchef/gitClones/ScreenUtil/screenutil"

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload -nn")
    hl.exec_cmd("swaync &")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("~/.config/waybar/scripts/launch.sh")
    hl.exec_cmd("swww-daemon")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-wlr.service")
    hl.exec_cmd("noisetorch -i alsa_input.usb-3142_fifine_Microphone_000000000000-00.mono-fallback")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    ecosystem = {
        enforce_permissions = true,
    },
})

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
hl.permission("/home/ttchef/coding/c++/hypr_plugin/", "plugin", "allow")

local hs = require("hyprsplit")
hs.config({
    num_workspaces = 3,
})

hl.config({
    general = {
        gaps_in = 8,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
})

hl.config({
    decoration = {
        rounding = 10,
        rounding_power = 2,

        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = true,
            size = 7,
            passes = 3,

            ignore_opacity = true,
            new_optimizations = true,

            noise = 0.08,
            contrast = 1.5,

            xray = false,

            vibrancy = 0.1696,
        },
    },
})

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

hl.animation({ leaf = "global",         enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",         enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",        enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",      enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",     enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",         enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",        enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",           enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",         enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",       enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",      enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",   enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",  enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",     enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",   enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut",  enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    xwayland = {
        enabled = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
})

hl.config({
    input = {
        kb_layout = "de,us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})


local mainMod = "SUPER"

-- Hotkeys
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("~/.config/waybar/scripts/launch.sh"))

-- Basics stuff
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("wlogout")) -- exit,
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(pMenu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(wMenu))
hl.bind(mainMod .. " + I", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + M", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("screendraw"))

hl.bind(mainMod .. " + H", hl.dsp.exec_raw("swapwindow l"))
hl.bind(mainMod .. " + L", hl.dsp.exec_raw("swapwindow r"))
hl.bind(mainMod .. " + K", hl.dsp.exec_raw("swapwindow u"))
hl.bind(mainMod .. " + J", hl.dsp.exec_raw("swapwindow d"))

-- Programs
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(discord))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obs"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Resize window
hl.bind("ALT + K", hl.dsp.window.resize({ x = 0,   y = -40, relative = true }))
hl.bind("ALT + J", hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }))
hl.bind("ALT + H", hl.dsp.window.resize({ x = -40, y = 0,   relative = true }))
hl.bind("ALT + L", hl.dsp.window.resize({ x = 40,  y = 0,   relative = true }))

hl.bind("ALT + UP",    hl.dsp.window.resize({ x = 0,   y = -80, relative = true }))
hl.bind("ALT + DOWN",  hl.dsp.window.resize({ x = 0,   y = 80,  relative = true }))
hl.bind("ALT + LEFT",  hl.dsp.window.resize({ x = -80, y = 0,   relative = true }))
hl.bind("ALT + RIGHT", hl.dsp.window.resize({ x = 80,  y = 0,   relative = true }))

for i = 1, 3 do
    hl.bind(mainMod .. " + " .. i, hs.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hs.dsp.window.move({ workspace = i, follow = false }))
end

-- Screenshot
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(screenshotter))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                   { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Swaync
hl.layer_rule({
    name = "swaync-control-center",
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "swaync-notification-window",
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0.5,
})
