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
	-- config = function()
	-- 	vim.api.nvim_create_autocmd('BufWritePre', {
	-- 		callback = function(event)
	-- 			local eslint_client = vim.lsp.get_active_clients({ bufnr = event.buf, name = 'eslint' })[1]
	-- 			if eslint_client then
	-- 				local diag = vim.diagnostic.get(
	-- 					event.buf,
	-- 					{ namespace = vim.lsp.diagnostic.get_namespace(eslint_client.id) }
	-- 				)
	-- 				if #diag > 0 then
	-- 					vim.cmd('EslintFixAll')
	-- 				end
	-- 			end
	-- 			-- config for prettier with conform.nvim
	-- 			-- require("conform").format({ bufnr = event.buf })
	-- 		end,
	-- 	})
	-- end,
	opts = {
		formatters_by_ft = {
			-- ["javascript"] = { "eslint_d" }, // eslint_d too slow so i use custom cmd
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
			local eslint_client = vim.lsp.get_active_clients({ bufnr = bufnr, name = 'eslint' })[1]
			if eslint_client then
				local diag = vim.diagnostic.get(
					bufnr,
					{ namespace = vim.lsp.diagnostic.get_namespace(eslint_client.id) }
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
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			}, on_format
		end
	},

	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
