return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>fb",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			-- ["javascript"] = { "eslint_d" }, -- eslint_d too slow so i use custom cmd
			-- ["typescript"] = { "eslint_d" },
			-- ["typescriptreact"] = { "eslint_d" },
			-- ["javascriptreact"] = { "eslint_d" },
			["css"] = { "prettier" },
			["scss"] = { "prettier" },
			["less"] = { "prettier" },
			["html"] = { "prettier" },
			["json"] = { "prettier" },
			["jsonc"] = { "prettier" },
			["lua"] = { "lua_ls" },
			-- ["yaml"] = { "prettier" },
		},
		format_on_save = function(bufnr)
			-- keep eslint-lsp version is 4.8.0 because in 4.10.0 diagnostic cant show eslint message with nvim version < 0.10
			local eslint_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'eslint' })[1]

			if eslint_client then
				local eslint_diag_ns = vim.lsp.diagnostic.get_namespace(eslint_client.id);

				local diag = vim.diagnostic.count(
					bufnr,
					{
						namespace = eslint_diag_ns,
						severity = {
							vim.diagnostic.severity.WARN,
							vim.diagnostic.severity.ERROR,
						}
					}
				)

				if #diag > 0 then
					vim.cmd('EslintFixAll')
					return
				end
			end

			local function on_format(err)
				if err and err:match("timeout$") then
					slow_format_filetypes[vim.bo[bufnr].filetype] = true
				end
			end

			return {
				lsp_fallback = false,
				async = false,
				timeout_ms = 1000,
			}, on_format
		end
	},

	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
