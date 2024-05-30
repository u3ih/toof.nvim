return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = false,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		'williamboman/mason.nvim',
		lazy = false,
		config = true,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{ 'L3MON4D3/LuaSnip' },
			{ 'onsails/lspkind.nvim' },
		},
		config = function()
			require('lsp-zero.cmp').extend()

			local cmp         = require('cmp')
			local lspkind     = require('lspkind')
			local icons       = require('config.icons')
			local cmp_action  = require('lsp-zero.cmp').action()
			local cmp_mapping = cmp.mapping
			local cmp_types   = require('cmp.types.cmp')
			local luasnip     = require('luasnip')
			local utils       = require('config.utils')
			cmp.setup({
				matching = {
					disallow_partial_fuzzy_matching = false
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local max_width = 0
						if max_width ~= 0 and #vim_item.abbr > max_width then
							vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) ..
									icons.ui.Ellipsis
						end
						vim_item.kind = lspkind.presets.default[vim_item.kind] ..
								" " .. vim_item.kind

						if entry.source.name == "copilot" then
							vim_item.kind = icons.git.Octoface
							vim_item.kind_hl_group = "CmpItemKindCopilot"
						end

						if entry.source.name == "crates" then
							vim_item.kind = icons.misc.Package
							vim_item.kind_hl_group = "CmpItemKindCrate"
						end

						if entry.source.name == "emoji" then
							vim_item.kind = icons.misc.Smiley
							vim_item.kind_hl_group = "CmpItemKindEmoji"
						end
						vim_item.menu = ({
							nvim_lsp = "(LSP)",
							emoji = "(Emoji)",
							path = "(Path)",
							calc = "(Calc)",
							vsnip = "(Snippet)",
							luasnip = "(Snippet)",
							buffer = "(Buffer)",
							tmux = "(TMUX)",
							copilot = "(Copilot)",
							treesitter = "(TreeSitter)",
						})[entry.source.name]
						-- vim_item.dup = ({
						-- 	buffer = 1,
						-- 	path = 1,
						-- 	nvim_lsp = 0,
						-- 	luasnip = 1,
						-- })[entry.source.name] or 0
						return vim_item
					end,
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered({
						winhighlight =
						"Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					}),
					documentation = cmp.config.window.bordered({
						winhighlight =
						"Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					}),
				},
				sources = {
					{
						name = "copilot",
						-- keyword_length = 0,
						max_item_count = 3,
						trigger_characters = {
							{
								".",
								":",
								"(",
								"'",
								'"',
								"[",
								",",
								"#",
								"*",
								"@",
								"|",
								"=",
								"-",
								"{",
								"/",
								"\\",
								"+",
								"?",
								" ",
								-- "\t",
								-- "\n",
							},
						},
					},
					{
						name = "nvim_lsp",
						entry_filter = function(entry, ctx)
							local kind = require("cmp.types.lsp").CompletionItemKind
									[entry:get_kind()]
							if kind == "Snippet" and ctx.prev_context.filetype == "java" then
								return false
							end
							if kind == "Text" then
								return false
							end
							return true
						end,
					},

					{ name = "path" },
					{ name = "luasnip" },
					{ name = "nvim_lua" },
					{ name = "buffer" },
					{ name = "calc" },
					{ name = "emoji" },
					{ name = "treesitter" },
					{ name = "crates" },
					{ name = "tmux" },
				},
				mapping = {
					['<Tab>'] = cmp_action.luasnip_supertab(),
					['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
					["<C-Space>"] = cmp_mapping.complete(),
					['<CR>'] = cmp.mapping.confirm({ select = false }),
				}
			})
		end
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
				-- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
					opts)
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
					-- "eslint_d"
				}
			})
			require('mason-lspconfig').setup({
				ensure_installed = {
					'tsserver',
					'eslint',
					'lua_ls',
					'jsonls',
					'cssls',
					'vimls',
					'tailwindcss',
					-- 'rust-analyzer',
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
					-- lspconfig.solidity.setup({
					-- 	cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
					-- 	filetypes = { "solidity", "sol" },
					-- 	root_dir = require("lspconfig.util").find_git_ancestor,
					-- 	single_file_support = true,
					-- }),

					lspconfig.jsonls.setup({
						settings = {
							json = {
								schema = require('schemastore').json.schemas(),
								validate = { enable = true },
							}
						}
					}),

					lspconfig.tsserver.setup({
						root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json",
							"jsconfig.json"),
						filetypes = { 'javascript', 'javascriptreact', 'typescript',
							'typescriptreact' },
						cmd = { "typescript-language-server", "--stdio" },
					}),


					lspconfig.eslint.setup({
						filetypes = { 'javascript', 'javascriptreact', 'typescript',
							'typescriptreact' },
						settings = {
							workingDirectory = {
								mode = "auto"
							},
							format = { enable = true },
							lint = { enable = true },
						},
					}),

					lspconfig.rust_analyzer.setup({
						settings = {
							["rust-analyzer"] = {
								lens = {
									enable = true,
								},
								cargo = {
									allFeatures = true,
									loadOutDirsFromCheck = true,
									runBuildScripts = true,
								},
								-- Add clippy lints for Rust.
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

					-- lspconfig.terraformls.setup({
					-- 	cmd = { "terraform-ls", "serve" },
					-- 	filetypes = { "terraform", "tf", "terraform-vars" },
					-- 	-- root_dir = lspconfig.util.root_pattern(".terraform", ".git"),
					-- 	root_dir = lspconfig.util.root_pattern("*.tf", "*.terraform", "*.tfvars",
					-- 		"*.hcl", "*.config"),
					-- })
				},
			})

			lsp_zero.set_preferences({
				suggest_lsp_servers = true,
			})

			lsp_zero.set_sign_icons({
				error = "🤬",
				warn = "😤",
				info = "🤔",
				hint = "🤯",
			})

			vim.diagnostic.config({
				title            = false,
				underline        = true,
				virtual_text     = true,
				signs            = true,
				update_in_insert = true,
				severity_sort    = true,
				float            = {
					source = "always",
					style = "minimal",
					border = "rounded",
					header = "",
					prefix = "",
				},
			})
		end
	}
}
