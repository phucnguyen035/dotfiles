local wezterm = require("wezterm")
local act = wezterm.action

return {
	{
		key = "v",
		mods = "CMD",
		action = act.PasteFrom("Clipboard"),
	},
}
