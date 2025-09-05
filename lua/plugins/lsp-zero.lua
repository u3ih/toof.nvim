return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		'williamboman/mason.nvim',
		config = true,
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		cmd = 'LspInfo',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'b0o/schemastore.nvim' },
			{ 'WhoIsSethDaniel/mason-tool-installer.nvim' }
		},
		config = function()
			-- Helper function to check node version
			local function check_node_version()
				local node_path = vim.fn.expand("$HOME") .. "/.nvm/versions/node/v20.8.1/bin/node"
				if vim.fn.filereadable(node_path) == 0 then
					vim.notify("Node v20.8.1 not found at " .. node_path, vim.log.levels.ERROR)
					vim.notify("Please install nvm, node v20.8.1 to use eslint, ts_ls")
					return false, node_path
				end
				return true, node_path
			end

			local node_version_ok, node_path = check_node_version()

			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_lspconfig()
			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr })
				local opts = { buffer = bufnr, silent = true }
				vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
				vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<cr>', opts)
				vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
				vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
				vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
				vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
				vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
			end)

			local lspconfig = require('lspconfig')

			require('mason').setup({})
			require('mason-tool-installer').setup({
				ensure_installed = {
					'prettier',
				}
			})

			require('mason-lspconfig').setup({
				automatic_installation = true,
				ensure_installed = {
					'ts_ls',
					"solidity_ls_nomicfoundation",
					'eslint',
					'lua_ls',
					'jsonls',
					'cssls',
					'vimls',
					'tailwindcss',
					'rust_analyzer',
				},
				handlers = {
					lsp_zero.default_setup,
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim", "custom_nvim" },
								},
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
									hint = { enable = true },
									telemetry = { enable = false },
								},
							},
						},
					}),
					lspconfig.jsonls.setup({
						settings = {
							json = {
								schema = require('schemastore').json.schemas(),
								validate = { enable = true },
							}
						}
					}),

					lspconfig.ts_ls.setup({
						single_file_support = true,
						settings = {
							workingDirectory = { mode = "auto" },
						},
						init_options = {
							preferences = {
								importModuleSpecifierPreference = "non-relative", -- or "shortest"
								includeCompletionsForModuleExports = true,
								includeCompletionsWithInsertText = true,
							},
						},
						filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
						cmd = {
							node_path,
							vim.fn.stdpath("data") ..
							"/mason/packages/typescript-language-server/node_modules/typescript-language-server/lib/cli.mjs",
							"--stdio"
						}
					}),

					lspconfig.eslint.setup({
						cmd = {
							node_path,
							vim.fn.stdpath("data") ..
							"/mason/packages/eslint-lsp/node_modules/vscode-langservers-extracted/bin/vscode-eslint-language-server",
							"--stdio"
						},
						settings = {
							workingDirectory = { mode = "auto" },
							format = { enable = true },
							lint = { enable = true },
							codeActionOnSave = {
								enable = false,
								mode = 'all',
							},
						},
						on_attach = function(client)
							client.server_capabilities.definitionProvider = false
						end,
					}),

					lspconfig.rust_analyzer.setup({
						settings = {
							["rust-analyzer"] = {
								lens = { enable = true },
								cargo = {
									allFeatures = true,
									loadOutDirsFromCheck = true,
									runBuildScripts = true,
								},
								check = {
									enable = true,
									allFeatures = true,
									command = "clippy",
									extraArgs = { "--no-deps" },
								},
								procMacro = {
									enable = true,
									ignored = {
										["async-trait"] = { "async_trait" },
										["napi-derive"] = { "napi" },
										["async-recursion"] = { "async_recursion" },
									},
								},
							},
						},
					}),
				},
			})

			lsp_zero.set_preferences({
				suggest_lsp_servers = true,
			})

			local icons = require('utils.icons')
			vim.diagnostic.config({
				underline        = true,
				virtual_text     = true,
				signs            = {
					text = icons.diagnostics,
					numhl = {
						[vim.diagnostic.severity.ERROR] = 'ErrorMsg',
						[vim.diagnostic.severity.WARN] = 'WarningMsg',
					},
				},
				update_in_insert = true,
				severity_sort    = true,
				float            = {
					source = true,
					style = "minimal",
					border = "rounded",
					header = "",
					prefix = "",
				},
			})
		end
	}
}
