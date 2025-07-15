return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{
			"benomahony/oil-git.nvim",
			enabled = false,
			-- opts = {
			-- 	highlights = {
			-- 		OilGitModified = { fg = "#ff0000" }, -- Custom colors
			-- 	}
			-- }
		},
		{
			"refractalize/oil-git-status.nvim",
			config = true,
			enabled = false,
		},
		{
			"JezerM/oil-lsp-diagnostics.nvim",
			opts = {}
		}
	},
	opts = {
		keymaps = {
			["?"] = "actions.show_help",
			["<Esc>"] = "actions.close",
			["<"] = "actions.parent",
			["<C-o>"] = "actions.copy_entry_filename",
			["<C-O>"] = "actions.copy_entry_path",
			["<C-r>"] = "actions.refresh",
		},
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
			natural_order = true,
			is_always_hidden = function(name, _)
				return name == '..' or name == '.git'
			end,
		},
		win_options = {
			wrap = true,
		}
	}
}
