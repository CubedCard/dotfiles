-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
hl.unbind("SUPER + RETURN")
hl.unbind("SUPER + SLASH")
o.bind("SUPER + SLASH", "Terminal", { omarchy = "terminal" })
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Unbind SUPER+MINUS (was: expand window left) to open the default browser.
hl.unbind("SUPER + code:20")
o.bind("SUPER + code:20", "Browser", { omarchy = "browser" })

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Rectangle-style window snapping (Ctrl+Alt = Ctrl+Option on macOS)
local rect = "~/.config/hypr/rectangle.sh "
local function snap(key, action, desc)
  o.bind("CTRL + ALT + " .. key, desc, rect .. action)
end
snap("LEFT", "left", "Snap left half")
snap("RIGHT", "right", "Snap right half")
snap("UP", "top", "Snap top half")
snap("DOWN", "bottom", "Snap bottom half")
snap("U", "tl", "Snap top left")
snap("I", "tr", "Snap top right")
snap("J", "bl", "Snap bottom left")
snap("K", "br", "Snap bottom right")
snap("D", "first-third", "Snap first third")
snap("F", "center-third", "Snap center third")
snap("G", "last-third", "Snap last third")
snap("E", "first-two-thirds", "Snap first two thirds")
snap("T", "last-two-thirds", "Snap last two thirds")
snap("RETURN", "maximize", "Maximize window")
snap("C", "center", "Center window")
snap("BACKSPACE", "restore", "Restore window")
snap("MINUS", "smaller", "Make window smaller")
snap("EQUAL", "larger", "Make window larger")
o.bind("CTRL + ALT + SUPER + LEFT", "Move window to previous monitor", hl.dsp.window.move({ monitor = "-1" }))
o.bind("CTRL + ALT + SUPER + RIGHT", "Move window to next monitor", hl.dsp.window.move({ monitor = "+1" }))

-- "Minimize": hide window in a separate special workspace without closing it
o.bind("SUPER + M", "Minimize window", hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
o.bind("SUPER + ALT + M", "Toggle minimized windows", hl.dsp.workspace.toggle_special("minimized"))

-- Alt-Tab style window switching on SUPER+TAB (replaces next/previous workspace)
hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")
o.bind("SUPER + TAB", "Focus on next window", hl.dsp.window.cycle_next())
o.bind("SUPER + SHIFT + TAB", "Focus on previous window", hl.dsp.window.cycle_next({ next = false }))
o.bind("SUPER + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
o.bind("SUPER + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
