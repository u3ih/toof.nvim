local colors = require("config.colors").colors
return {
	"akinsho/bufferline.nvim",
	enabled = false,
	event = "VeryLazy",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function(_, opts)
		require("bufferline").setup(opts)
		-- Fix bufferline when restoring a session
		vim.api.nvim_create_autocmd("BufAdd", {
			callback = function()
				vim.schedule(function()
					pcall(nvim_bufferline)
				end)
			end,
		})
	end,
	opts = {
		options = {
			separator_style = { "", "" },
			-- indicator = { style = "none" },
			-- show_tab_indicators = false,

			always_show_bufferline = false,
			show_close_icon = false,
			show_buffer_close_icons = false,
			-- tab_size = 0,
			max_name_length = 25,
			offsets = {
				{
					filetype = "neo-tree",
					text = "  Project",
					highlight = "Directory",
					text_align = "left",
				},
			},
			modified_icon = "",
		},

		highlights = {
			fill = {
				bg = "",
			},
			background = {
				bg = "",
			},
			tab = {
				bg = "",
			},
			tab_close = {
				bg = "",
			},
			tab_separator = {
				fg = colors.bg,
				bg = "",
			},
			tab_separator_selected = {
				fg = colors.bg,
				bg = "",
				sp = colors.fg,
			},
			close_button = {
				bg = "",
				fg = colors.fg,
			},
			close_button_visible = {
				bg = "",
				fg = colors.fg,
			},
			close_button_selected = {
				fg = { attribute = "fg", highlight = "StatusLineNonText" },
			},
			buffer_visible = {
				bg = "",
			},
			modified = {
				bg = "",
			},
			modified_visible = {
				bg = "",
			},
			duplicate = {
				fg = colors.fg,
				bg = ""
			},
			duplicate_visible = {
				fg = colors.fg,
				bg = ""
			},
			separator = {
				fg = colors.bg,
				bg = ""
			},
			separator_selected = {
				fg = colors.bg,
				bg = ""
			},
			separator_visible = {
				fg = colors.bg,
				bg = ""
			},
			offset_separator = {
				fg = colors.bg,
				bg = ""
			},
		},
	},
}
