return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
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
