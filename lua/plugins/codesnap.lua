return {
	"mistricky/codesnap.nvim",
	version = "1.1.5",
	build = "make build_generator",
	lazy = true,
	cmd = "CodeSnap",
	opts = {
		watermark = "toof",
		border = "rounded",
		has_breadcrumbs = true,
		bg_theme = "grape",
		mac_window_bar = false,
	},
	config = function(_, opts)
		require("codesnap").setup(opts)
	end
}
