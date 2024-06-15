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
	}
}
