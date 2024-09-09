return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	lazy = true,
	opts = {
		plugins = {
			marks = false,  -- shows a list of your marks on ' and `
			registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
			-- No actual key bindings are created
			presets = {
				operators = false, -- adds help for operators like d, y, ...
				motions = false,  -- adds help for motions
				text_objects = false, -- help for text objects triggered after entering an operator
				windows = false,  -- default bindings on <c-w>
				nav = false,      -- misc bindings to work with windows
				z = false,        -- bindings for folds, spelling and others prefixed with z
				g = false,        -- bindings for prefixed with g
			},
		},
		triggers = {
			{ "<auto>", mode = "n" },
		},
		win = {
			no_overlap = true,
			border = "none", -- none, single, double, shadow
			padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
			title = true,
			title_pos = "center",
			zindex = 1000, -- positive value to position WhichKey above other floating windows.
			wo = {
				winblend = 0,
			}
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3,                 -- spacing between columns
			align = "center",            -- align columns left, center or right
		},
		-- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
		show_help = true, -- show help message on the command line when the popup is visible
		show_keys = true,
		-- Disabled by default for Telescope
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
		debug = false
	},
	config = function(_, opts)
		local which_key = require("which-key")
		which_key.setup(opts)
		which_key.add(require('config.which-key.defaults'))
		which_key.add(require('config.which-key.non_leader'))
	end
}
