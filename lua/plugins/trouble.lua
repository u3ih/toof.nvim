return {
	"folke/trouble.nvim",
	cmd = { "TroubleToggle", "Trouble" },
	opts = { use_diagnostic_signs = true },
	lazy = true,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("trouble").setup {
			-- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
			mode = "workspace_diagnostics",
			position = "bottom", -- position of the list can be: bottom, top, left, right
			height = 15,
			padding = false,
			auto_jump = {},
			use_diagnostic_signs = true,
		}
	end
}
