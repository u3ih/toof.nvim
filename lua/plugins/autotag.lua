return {
	"windwp/nvim-ts-autotag",
	lazy = true,
	opts = {
		autotag = {
			enable = true,
			nable_rename = true,
			enable_close = true,
			enable_close_on_slash = true,
			filetypes = { 'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
		}
	}
}
