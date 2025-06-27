local function biome_lsp_or_prettier(bufnr)
	local has_biome_lsp = vim.lsp.get_clients({
		bufnr = bufnr,
		name = "biome",
	})[1]
	if has_biome_lsp then
		return { "biome" }
	end
	local has_prettier = vim.fs.find({
		-- https://prettier.io/docs/en/configuration.html
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.json5",
		".prettierrc.js",
		".prettierrc.cjs",
		".prettierrc.toml",
		"prettier.config.js",
		"prettier.config.cjs",
	}, { upward = true })[1]
	if has_prettier then
		return { "prettier" }
	end
	return { "biome" }
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	log_level = vim.log.levels.DEBUG,
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
			-- ["javascript"] = biome_lsp_or_prettier, -- eslint_d too slow so i use custom cmd
			-- ["typescript"] = "eslint_d",
			-- ["typescriptreact"] = biome_lsp_or_prettier,
			-- ["javascriptreact"] = biome_lsp_or_prettier,
			["css"] = { "prettier", stop_after_first = true },
			["scss"] = { "prettier", stop_after_first = true },
			["less"] = { "prettier", stop_after_first = true },
			["html"] = { "prettier", stop_after_first = true },
			["json"] = { "prettier", stop_after_first = true },
			["jsonc"] = { "prettier", stop_after_first = true },
			-- ["lua"] = { "lua_ls" },
			-- ["yaml"] = { "prettier" },
		},
		prettier = {
			condition = function(ctx)
				return require("conform.util").root_has_file({
					".prettierrc",
					".prettierrc.json",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.yaml",
					".prettierrc.yml",
					".prettierrc.toml",
					"prettier.config.js",
					"prettier.config.cjs",
				})(ctx)
			end,
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = 'first',
			filter = function(client)
				return client.name == 'eslint'
			end,
		},
		format_after_save = function(bufnr)
			-- keep eslint-lsp version is 4.8.0 because in 4.10.0 diagnostic cant show eslint message with nvim version < 0.10
			local eslint_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'eslint' })[1]
			local biome_lsp = vim.lsp.get_clients({
				bufnr = bufnr,
				name = "biome",
			})[1]

			if eslint_client then
				local eslint_diag_ns = vim.lsp.diagnostic.get_namespace(eslint_client.id);

				local diag = vim.diagnostic.count(
					bufnr,
					{
						namespace = eslint_diag_ns,
						severity = {
							vim.diagnostic.severity.ERROR,
						}
					}
				)

				if #diag > 0 then
					vim.cmd('EslintFixAll')
					return
				end
			end

			if biome_lsp then
				local biome_diag_ns = vim.lsp.diagnostic.get_namespace(biome_lsp.id);

				local diag = vim.diagnostic.count(
					bufnr,
					{
						namespace = biome_diag_ns,
						severity = {
							vim.diagnostic.severity.ERROR,
						}
					}
				)

				if #diag > 0 then
					vim.cmd('!npx @biomejs/biome check --write %')
					return
				end
			end

			local function on_format(err)
				-- if err and err:match("timeout$") then
				-- 	slow_format_filetypes[vim.bo[bufnr].filetype] = true
				-- end
			end

			return {
				lsp_fallback = true,
				async = true,
				bufnr,
				timeout_ms = 500,
			}, on_format
		end
	},

	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
