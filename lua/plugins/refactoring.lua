return {
	"ThePrimeagen/refactoring.nvim",
	enabled = false,
	lazy = true,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" }
	},
	config = function()
		require("refactoring").setup({})
	end
}
