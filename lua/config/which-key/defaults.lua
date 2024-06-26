function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end

-- Live grep with selected string
function searchWithCurrentSelectedText()
	local text = vim.getVisualSelection()
	require('telescope.builtin').live_grep({ default_text = text, additional_args = { "--fixed-strings" } })
end

return {
	mode = { "n", "v" },
	p = { "<cmd>Telescope treesitter<CR>", "List Symbols" },
	v = "Go to definition in a split",
	a = "Swap next param",
	A = "Swap previous param",
	U = { ":UndotreeToggle<CR>", "Toggle UndoTree" },
	x = { ":NoiceDismiss<CR>", "Dismiss Notice" },
	u = {
		name = "UI",
		c = { "<cmd>lua require('utils.lsp-utils').toggle_set_color_column()<CR>", "Toggle Color Line" },
		l = { "<cmd>lua require('utils.lsp-utils').toggle_cursor_line()<CR>", "Toggle Cursor Line" },
		b = { "<cmd>lua require('utils.lsp-utils').change_background()<CR>", "Toggle Background" },
	},
	i = {
		name = "Sessions",
		s    = { "<cmd>lua require('persistence').load()<cr>", "Load Session" },
		l    = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Load Last Session" },
		d    = { "<cmd>lua require('persistence').stop()<cr>", "Stop Persistence" },
	},
	m = {
		name = "Marks",
		m = { "<cmd>Telescope marks<cr>", "Marks" },
	},
	r = {
		name = "Replace",
		t = { "<cmd>lua require('spectre').toggle()<cr>", "Toggle" },
		r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
		w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
		f = { "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>", "Replace In Current Buffer" },
	},
	b = {
		name = "Buffers",
		-- j = { "<cmd>BufferLinePick<cr>", "Jump" },
		f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
		-- b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
		-- n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
		W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
		e = {
			"<cmd>BufferLinePickClose<cr>",
			"Pick which buffer to close",
		},
		l = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
		r = {
			"<cmd>BufferLineCloseRight<cr>",
			"Close all to the right",
		},
		o = {
			"<Cmd>BufferLineCloseOthers<CR>",
			"Delete other buffers"
		},
		d = {
			":bd<CR>",
			"Close Buffer"
		},
		-- D = {
		--   "<cmd>BufferLineSortByDirectory<cr>",
		--   "Sort by directory",
		-- },
		-- L = {
		--   "<cmd>BufferLineSortByExtension<cr>",
		--   "Sort by language",
		-- },
		p = { "<cmd>BufferLineTogglePin<CR>", "Toggle pin" },
		P = { "<cmd>BufferLineGroupClose ungrouped<CR>", "Delete non-pinned buffers" },
	},
	g = {
		name = "+Git",
		t = { "<cmd>lua require 'gitsigns'.toggle_current_line_blame()<cr>", "Toggle Line blame" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			"Undo Stage Hunk",
		},
		g = {
			"<cmd>:LazyGit<cr>",
			"Lazygit"
		},
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		d = {
			"<cmd>DiffviewFileHistory %<cr>",
			"Git Diff",
		},
		x = {
			"<cmd>DiffviewClose<cr>",
			"Git Diff Close",
		},
	},
	l = {
		name = "+LSP",
		l = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Document Diagnostics (Trouble)" },
		L = { "<cmd>Trouble diagnostics toggle<cr>", "Workspace Diagnostics (Trouble)" },
		w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
		r = { [[ <Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>]], "Refactor" },
		h = { "<cmd>lua require('utils.lsp-utils').toggle_inlay_hints()<CR>", "Toggle Inlay Hints" },

		p = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "previous diagnostic" },
		n = { "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "next diagnostic" },
		e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
	},
	s = {
		name = "+Search",
		f = { "<cmd>Telescope find_files hidden=true<cr>", "Find File (CWD)" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		g = { '<cmd>lua searchWithCurrentSelectedText()<cr>', "Live grep fixed string" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
		l = { "<cmd>Telescope resume<cr>", "Resume last search" },
		c = { "<cmd>Telescope git_commits<cr>", "Git commits" },
		B = { "<cmd>Telescope git_branches<cr>", "Git branches" },
		s = { "<cmd>Telescope git_status<cr>", "Git status" },
		S = { "<cmd>Telescope git_stash<cr>", "Git stash" },
		z = { "<cmd>Telescope zoxide list<cr>", "Zoxide" },
		e = { "<cmd>Telescope frecency<cr>", "Frecency" },
		b = { "<cmd>Telescope buffers<cr>", "Buffers" },
		p = { "<cmd>Telescope aerial<cr>", "Areal Toggle" },
		r = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]] },
		d = {
			name = "+DAP",
			c = { "<cmd>Telescope dap commands<cr>", "Dap Commands" },
			b = { "<cmd>Telescope dap list_breakpoints<cr>", "Dap Breakpoints" },
			g = { "<cmd>Telescope dap configurations<cr>", "Dap Configurations" },
			v = { "<cmd>Telescope dap variables<cr>", "Dap Variables" },
			f = { "<cmd>Telescope dap frames<cr>", "Dap Frames" },
		}
	},
	T = {
		name = "+Todo",
		t = { "<cmd>TodoTrouble<cr>", "Todo (Trouble)" },
		T = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme (Trouble)" },
		n = { "<cmd>lua require ('todo-comments').jump_next()<cr>", "Next todo comment" },
		p = { "<cmd>lua require ('todo-comments').jump_prev()<cr>", "Previous todo comment" },
	},
	d = {
		name = "Debug",
		b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
		o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
		O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
		l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
		u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
		x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
		d = { "<cmd>lua require'dap'.disconnect()<cr>", "Detach" },
	},
	o = {
		name = "+Oil explorer",
		o = {
			"<Cmd>Oil<CR>",
			"Oil Open"
		},
		t = {
			":lua require('oil').toggle_float()<cr>",
			"Oil toggle"
		},
		s = {
			":lua require('oil').save({confirm = false})<cr>",
			"Oil save"
		},
		x = {
			":lua require('oil').discard_all_changes()<cr>",
			"Oil discard all change"
		}
	},
	-- n = {
	-- 	name = "+NeoTree",
	-- 	t = {
	-- 		"<Cmd>Neotree toggle<CR>",
	-- 		"Neotree toggle"
	-- 	},
	-- 	r = {
	-- 		"<Cmd>Neotree reveal<CR>",
	-- 		"Neotree reveal"
	-- 	},
	-- 	b = {
	-- 		"<Cmd>Neotree buffers<CR>",
	-- 		"Neotree buffers"
	-- 	},
	-- 	s = {
	-- 		"<Cmd>Neotree document_symbols<CR>",
	-- 		"Neotree document symbols"
	-- 	},
	-- },
	f = {
		name = "+Format",
		e = { "<cmd>EslintFixAll<cr>", "Fix Eslint" },
	},
	t = {
		name = "+Tests"
	},
}
