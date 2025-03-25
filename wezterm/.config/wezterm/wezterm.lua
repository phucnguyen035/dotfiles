local wezterm = require("wezterm")
local act = wezterm.action

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end

	return "Dark"
end

local function get_scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

local oled = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
oled.background = "#000000"
oled.tab_bar.background = "#040404"
oled.tab_bar.inactive_tab.bg_color = "#0f0f0f"
oled.tab_bar.new_tab.bg_color = "#080808"

local c = wezterm.config_builder()

c.freetype_load_target = "Light"
c.disable_default_key_bindings = true
c.color_schemes = {
	["OLEDppuccin"] = oled,
}
c.color_scheme = get_scheme_for_appearance(get_appearance())
c.default_cwd = wezterm.home_dir .. "/Projects"
c.font = wezterm.font("JetBrainsMono Nerd Font")
c.font_size = 15
c.line_height = 1.3
c.initial_cols = 200
c.initial_rows = 40
c.window_padding = {
	top = 16,
	bottom = 16,
}
c.inactive_pane_hsb = {
	brightness = 0.5,
}

-- TAB BAR SETTINGS
c.enable_tab_bar = true
c.hide_tab_bar_if_only_one_tab = true
c.use_fancy_tab_bar = false
c.tab_bar_at_bottom = false
c.show_new_tab_button_in_tab_bar = false
c.window_decorations = "RESIZE"
c.window_background_opacity = 1
c.macos_window_background_blur = 50
c.max_fps = 120

-- KEYBINDINGS
c.keys = {
	{
		key = "v",
		mods = "SUPER",
		action = act.PasteFrom("Clipboard"),
	},
	{
		key = "w",
		mods = "SUPER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "+",
		mods = "SUPER",
		action = act.IncreaseFontSize,
	},
	{
		key = "-",
		mods = "SUPER",
		action = act.DecreaseFontSize,
	},
	{
		key = "0",
		mods = "SUPER",
		action = act.ResetFontSize,
	},
}

return c
