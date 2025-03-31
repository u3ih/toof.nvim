return {
	-- Autocompletion
	-- enabled = false,
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{ 'L3MON4D3/LuaSnip' },
			{ 'onsails/lspkind.nvim' },
		},
		config = function()
			require('lsp-zero.cmp').extend({})

			local cmp         = require('cmp')
			local lspkind     = require('lspkind')
			local icons       = require('utils.icons')
			local cmp_action  = require('lsp-zero.cmp').action()
			local cmp_mapping = cmp.mapping
			local cmp_types   = require('cmp.types.cmp')
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
}
