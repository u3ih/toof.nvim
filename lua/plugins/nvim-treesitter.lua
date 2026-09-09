local ensure_installed = {
	"bash",
	"css",
	"go",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"query",
	"regex",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup({})

			local installed = ts.get_installed("parsers")
			local missing = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(installed, lang)
			end, ensure_installed)
			if #missing > 0 then
				ts.install(missing)
			end

			-- `incremental_selection` was dropped in the nvim-treesitter rewrite.
			-- Minimal replacement: <leader>vv starts, + grows, _ shrinks.
			local sel_stack = {}
			local function sel_set(node)
				local sr, sc, er, ec = node:range()
				vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
				vim.fn.setpos("'>", { 0, er + 1, ec, 0 })
				vim.cmd("normal! gv")
			end

			vim.keymap.set("n", "<leader>vv", function()
				local node = vim.treesitter.get_node()
				if not node then
					return
				end
				sel_stack = { node }
				sel_set(node)
			end, { desc = "Start incremental selection" })

			vim.keymap.set("x", "+", function()
				local node = sel_stack[#sel_stack] or vim.treesitter.get_node()
				if not node then
					return
				end
				local parent = node:parent()
				while parent and parent:range() == node:range() do
					parent = parent:parent()
				end
				if parent then
					table.insert(sel_stack, parent)
					sel_set(parent)
				else
					sel_set(node)
				end
			end, { desc = "Increment node selection" })

			vim.keymap.set("x", "_", function()
				if #sel_stack > 1 then
					table.remove(sel_stack)
				end
				local node = sel_stack[#sel_stack]
				if node then
					sel_set(node)
				end
			end, { desc = "Decrement node selection" })

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ts_start", { clear = true }),
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft)
					if not lang or not vim.tbl_contains(ts.get_installed("parsers"), lang) then
						return
					end

					pcall(vim.treesitter.start, args.buf)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@parameter.inner"] = "v",
						["@function.outer"] = "v",
						["@conditional.outer"] = "V",
						["@loop.outer"] = "V",
						["@class.outer"] = "<c-v>",
					},
					include_surrounding_whitespace = false,
				},
				move = { set_jumps = true },
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")

			local textobjects = {
				["af"] = { "@function.outer", "around a function" },
				["if"] = { "@function.inner", "inner part of a function" },
				["ac"] = { "@class.outer", "around a class" },
				["ic"] = { "@class.inner", "inner part of a class" },
				["ai"] = { "@conditional.outer", "around an if statement" },
				["ii"] = { "@conditional.inner", "inner part of an if statement" },
				["al"] = { "@loop.outer", "around a loop" },
				["il"] = { "@loop.inner", "inner part of a loop" },
				["ap"] = { "@parameter.outer", "around parameter" },
				["ip"] = { "@parameter.inner", "inside a parameter" },
			}
			for lhs, spec in pairs(textobjects) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					select.select_textobject(spec[1], "textobjects")
				end, { desc = spec[2] })
			end

			local moves = {
				["]f"] = { "@function.outer", "goto_next_start", "Next function" },
				["]c"] = { "@class.outer", "goto_next_start", "Next class" },
				["]p"] = { "@parameter.inner", "goto_next_start", "Next parameter" },
				["[f"] = { "@function.outer", "goto_previous_start", "Previous function" },
				["[c"] = { "@class.outer", "goto_previous_start", "Previous class" },
				["[p"] = { "@parameter.inner", "goto_previous_start", "Previous parameter" },
			}
			for lhs, spec in pairs(moves) do
				vim.keymap.set({ "n", "x", "o" }, lhs, function()
					move[spec[2]](spec[1], "textobjects")
				end, { desc = spec[3] })
			end

			vim.keymap.set("n", "<leader>a", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap next parameter" })
			vim.keymap.set("n", "<leader>A", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Swap previous parameter" })
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
		},
	},
}
