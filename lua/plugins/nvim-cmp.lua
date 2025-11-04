return {
	-- Autocompletion
	-- enabled = false,
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{ 'onsails/lspkind.nvim' },
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
				config = function(_, opts)
					require("luasnip").config.set_config(opts)
				end,
			},
			-- autopairing of (){}[] etc
			{
				"windwp/nvim-autopairs",
				opts = {
					fast_wrap = {},
					disable_filetype = { "TelescopePrompt", "vim" },
				},
				config = function(_, opts)
					require("nvim-autopairs").setup(opts)

					-- setup cmp for autopairs
					local cmp_autopairs = require "nvim-autopairs.completion.cmp"
					require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
				-- co
			},

			-- cmp sources plugins
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"https://codeberg.org/FelipeLema/cmp-async-path.git"
			},
			{
				"zbirenbaum/copilot-cmp",
				enabled = true,
				dependencies = { "copilot.lua" },
				event = { "InsertEnter", "LspAttach" },
				fix_pairs = true,
				config = function()
					require("copilot_cmp").setup()
					-- attach cmp source whenever copilot attaches
					-- fixes lazy-loading issues with the copilot cmp source
					vim.api.nvim_create_autocmd("LspAttach", {
						callback = function(args)
							local buffer = args.buf ---@type number
							local client = vim.lsp.get_client_by_id(args.data.client_id)
							if client and (not "copilot" or client.name == "copilot") then
								return require("copilot_cmp")._on_insert_enter(client, buffer)
							end
						end,
					})
					local cmp = require "cmp"
					local current_sources = cmp.get_config().sources or {}
					table.insert(current_sources, {
						name = "copilot",
						priority = 100,
					})
					cmp.setup {
						sources = current_sources,
					}
				end,
			}
		},
		config = function()
			require('lsp-zero.cmp').extend({})

			-- is ther any code from copi
			local cmp         = require('cmp')
			local lspkind     = require('lspkind')
			local icons       = require('utils.icons')
			local cmp_action  = require('lsp-zero.cmp').action()
			local cmp_mapping = cmp.mapping
			local luasnip     = require('luasnip')
			local utils       = require('utils.lsp-utils')
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
						local kind_icon = lspkind.presets.default[vim_item.kind] or ""
						vim_item.kind = kind_icon .. " " .. vim_item.kind

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
						-- Remove show duplicate completion
						-- vim_item.dup = ({
						-- 	buffer = 1,
						-- 	path = 1,
						-- 	nvim_lsp = 0,
						-- 	luasnip = 1,
						-- })[entry.source.name] or 0
						return vim_item
					end,
				},
				--
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
					--
					documentation = cmp.config.window.bordered({
						winhighlight =
						"Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					}),
				},
				sources = {
					{
						name = "copilot",
						-- keyword_length = 0,
						group_index = 2,
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
					-- { name = "calc" },
					-- { name = "emoji" },
					{ name = "treesitter" },
					-- { name = "crates" },
					-- { name = "tmux" },
				},
				mapping = {
					['<Tab>'] = cmp_action.luasnip_supertab(),
					['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
					["<C-Space>"] = cmp_mapping.complete(),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-u>'] = cmp.mapping.scroll_docs(4),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}
			})
		end
	},
}
