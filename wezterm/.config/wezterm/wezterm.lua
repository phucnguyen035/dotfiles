local wezterm = require("wezterm")

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

local c = wezterm.config_builder()

c.color_scheme = "Catppuccin Mocha"
c.default_cwd = wezterm.home_dir .. "/Projects"
-- c.default_prog = { "/Users/phucnguyen/.cargo/bin/zellij", "-l", "welcome" }
c.font = wezterm.font("JetBrainsMono Nerd Font")
c.font_size = 15
c.line_height = 1.35
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
c.window_background_opacity = 0.9
c.macos_window_background_blur = 25
c.max_fps = 120

-- KEYBINDINGS
c.keys = require("keys")

return c
