return {
	"mistricky/codesnap.nvim",
	version = "1.1.5",
	-- cargo update -p time first: pinned time 0.3.34 fails E0282 on rustc >=1.80, breaking the build.
	build = "cargo update -p time --manifest-path generator/Cargo.toml && make build_generator",
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
