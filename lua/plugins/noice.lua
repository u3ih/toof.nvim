return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- add any options here
		background_colour = "#000000",
		position = "bottom_right", -- Set the position to right bottom
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		{ "rcarriga/nvim-notify", opts = { background_colour = "#000000" } },
	},
}
