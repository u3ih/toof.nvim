return {
	"folke/noice.nvim",
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		{ "rcarriga/nvim-notify", opts = { background_colour = "#000000" } },
	},
	config = function()
		require("noice").setup({
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				signature = {
					enabled = false,
				},
				hover = {
					enabled = false,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					-- ignore writtern message
					opts = { skip = true },
				},
				{

					filter = { event = "notify", find = "^.*WARNING.*vim.treesitter.get_parser.*$" },
					opts = { skip = true },
				}
			},
			presets = {
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = false,
			},
		})
	end,
	opts = {
		-- add any options here
		background_colour = "#000000",
		position = "bottom_right", -- Set the position to right bottom
	},
}
