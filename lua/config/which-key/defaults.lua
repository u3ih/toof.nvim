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
	{ "<leader>a",   desc = "Swap next param" },
	{ "<leader>A",   desc = "Swap previous param" },
	{ "<leader>p",   "<cmd>Telescope treesitter<CR>",                                              desc = "List Symbols" },
	{ "<leader>x",   ":NoiceDismiss<CR>",                                                          desc = "Dismiss Notice" },

	{ "<leader>T",   group = "Todo" },
	{ "<leader>TT",  "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",                               desc = "Todo/Fix/Fixme (Trouble)" },
	{ "<leader>Tn",  "<cmd>lua require('todo-comments').jump_next()<cr>",                          desc = "Next todo comment" },
	{ "<leader>Tp",  "<cmd>lua require('todo-comments').jump_prev()<cr>",                          desc = "Previous todo comment" },
	{ "<leader>Tt",  "<cmd>TodoTrouble<cr>",                                                       desc = "Todo (Trouble)" },

	{ "<leader>u",   group = "UI" },
	{ "<leader>U",   ":UndotreeToggle<CR>",                                                        desc = "Toggle UndoTree" },
	{ "<leader>ub",  "<cmd>lua require('utils.lsp-utils').change_background()<CR>",                desc = "Toggle Background" },
	{ "<leader>uc",  "<cmd>lua require('utils.lsp-utils').toggle_set_color_column()<CR>",          desc = "Toggle Color Line" },
	{ "<leader>v",   desc = "Go to definition in a split" },

	{ "<leader>b",   group = "Buffers" },

	{ "<leader>bP",  "<cmd>BufferLineGroupClose ungrouped<CR>",                                    desc = "Delete non-pinned buffers" },
	{ "<leader>bW",  "<cmd>noautocmd w<cr>",                                                       desc = "Save without formatting (noautocmd)" },
	{ "<leader>bd",  ":bd<CR>",                                                                    desc = "Close Buffer" },
	{ "<leader>be",  "<cmd>BufferLinePickClose<cr>",                                               desc = "Pick which buffer to close" },
	{ "<leader>bf",  "<cmd>Telescope buffers previewer=false<cr>",                                 desc = "Find" },
	{ "<leader>bl",  "<cmd>BufferLineCloseLeft<cr>",                                               desc = "Close all to the left" },
	{ "<leader>bo",  "<Cmd>BufferLineCloseOthers<CR>",                                             desc = "Delete other buffers" },
	{ "<leader>bp",  "<cmd>BufferLineTogglePin<CR>",                                               desc = "Toggle pin" },
	{ "<leader>br",  "<cmd>BufferLineCloseRight<cr>",                                              desc = "Close all to the right" },
	{ "<leader>d",   group = "Debug" },

	{ "<leader>dO",  "<cmd>lua require'dap'.step_out()<cr>",                                       desc = "Out" },
	{ "<leader>db",  "<cmd>lua require'dap'.toggle_breakpoint()<cr>",                              desc = "Breakpoint" },
	{ "<leader>dc",  "<cmd>lua require'dap'.continue()<cr>",                                       desc = "Continue" },
	{ "<leader>dd",  "<cmd>lua require'dap'.disconnect()<cr>",                                     desc = "Detach" },
	{ "<leader>di",  "<cmd>lua require'dap'.step_into()<cr>",                                      desc = "Into" },
	{ "<leader>dl",  "<cmd>lua require'dap'.run_last()<cr>",                                       desc = "Last" },
	{ "<leader>do",  "<cmd>lua require'dap'.step_over()<cr>",                                      desc = "Over" },
	{ "<leader>dr",  "<cmd>lua require'dap'.repl.toggle()<cr>",                                    desc = "Repl" },
	{ "<leader>du",  "<cmd>lua require'dapui'.toggle()<cr>",                                       desc = "UI" },
	{ "<leader>dx",  "<cmd>lua require'dap'.terminate()<cr>",                                      desc = "Exit" },

	{ "<leader>f",   group = "Format" },
	{ "<leader>fe",  "<cmd>EslintFixAll<cr>",                                                      desc = "Fix Eslint" },

	{ "<leader>g",   group = "Git" },
	{ "<leader>gR",  "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                             desc = "Reset Buffer" },
	{ "<leader>gd",  "<cmd>DiffviewFileHistory %<cr>",                                             desc = "Git Diff" },
	{ "<leader>gg",  "<cmd>:LazyGit<cr>",                                                          desc = "Lazygit" },
	{ "<leader>gj",  "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>",    desc = "Next Hunk" },
	{ "<leader>gk",  "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>",    desc = "Prev Hunk" },
	{ "<leader>gl",  "<cmd>lua require 'gitsigns'.blame_line()<cr>",                               desc = "Blame" },
	{ "<leader>go",  "<cmd>Telescope git_status<cr>",                                              desc = "Open changed file" },
	{ "<leader>gp",  "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",                             desc = "Preview Hunk" },
	{ "<leader>gr",  "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                               desc = "Reset Hunk" },
	{ "<leader>gs",  "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                               desc = "Stage Hunk" },
	{ "<leader>gt",  "<cmd>lua require 'gitsigns'.toggle_current_line_blame()<cr>",                desc = "Toggle Line blame" },
	{ "<leader>gu",  "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                          desc = "Undo Stage Hunk" },
	{ "<leader>gx",  "<cmd>DiffviewClose<cr>",                                                     desc = "Git Diff Close" },

	{ "<leader>i",   group = "Sessions" },
	{ "<leader>id",  "<cmd>lua require('persistence').stop()<cr>",                                 desc = "Stop Persistence" },
	{ "<leader>il",  "<cmd>lua require('persistence').load({ last = true })<cr>",                  desc = "Load Last Session" },
	{ "<leader>is",  "<cmd>lua require('persistence').load()<cr>",                                 desc = "Load Session" },

	{ "<leader>l",   group = "LSP" },
	{ "<leader>lL",  "<cmd>Trouble diagnostics toggle<cr>",                                        desc = "Workspace Diagnostics (Trouble)" },
	{ "<leader>le",  "<cmd>Telescope quickfix<cr>",                                                desc = "Telescope Quickfix" },
	{ "<leader>lh",  "<cmd>lua require('utils.lsp-utils').toggle_inlay_hints()<CR>",               desc = "Toggle Inlay Hints" },
	{ "<leader>ll",  "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                           desc = "Document Diagnostics (Trouble)" },
	{ "<leader>ln",  "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>",                                desc = "next diagnostic" },
	{ "<leader>lp",  "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",                                desc = "previous diagnostic" },
	{ "<leader>lr",  " <Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", desc = "Refactor" },
	{ "<leader>lw",  "<cmd>Telescope diagnostics<cr>",                                             desc = "Diagnostics" },
	{ "<leader>lk",  "<cmd>lua vim.diagnostic.open_float()<cr>",                                   desc = "Show full diagnostics" },

	{ "<leader>m",   group = "Marks" },
	{ "<leader>mm",  "<cmd>Telescope marks<cr>",                                                   desc = "Marks" },

	{ "<leader>o",   group = "Oil explorer" },
	{ "<leader>oo",  "<Cmd>Oil<CR>",                                                               desc = "Oil Open" },
	{ "<leader>os",  ":lua require('oil').save({confirm = false})<cr>",                            desc = "Oil save" },
	{ "<leader>ot",  ":lua require('oil').toggle_float()<cr>",                                     desc = "Oil toggle" },
	{ "<leader>ox",  ":lua require('oil').discard_all_changes()<cr>",                              desc = "Oil discard all change" },

	{ "<leader>r",   group = "Replace" },
	{ "<leader>rf",  "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>",       desc = "Replace In Current Buffer" },
	{ "<leader>rr",  "<cmd>lua require('spectre').open()<cr>",                                     desc = "Replace" },
	{ "<leader>rt",  "<cmd>lua require('spectre').toggle()<cr>",                                   desc = "Toggle" },
	{ "<leader>rw",  "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",            desc = "Replace Word" },

	{ "<leader>s",   group = "Search" },
	{ "<leader>sB",  "<cmd>Telescope git_branches<cr>",                                            desc = "Git branches" },
	{ "<leader>sC",  "<cmd>Telescope commands<cr>",                                                desc = "Commands" },
	{ "<leader>sH",  "<cmd>Telescope highlights<cr>",                                              desc = "Find highlight groups" },
	{ "<leader>sM",  "<cmd>Telescope man_pages<cr>",                                               desc = "Man Pages" },
	{ "<leader>sR",  "<cmd>Telescope registers<cr>",                                               desc = "Registers" },
	{ "<leader>sS",  "<cmd>Telescope git_stash<cr>",                                               desc = "Git stash" },
	{ "<leader>sb",  "<cmd>Telescope buffers<cr>",                                                 desc = "Buffers" },
	{ "<leader>sc",  "<cmd>Telescope git_commits<cr>",                                             desc = "Git commits" },

	{ "<leader>sd",  group = "DAP" },
	{ "<leader>sdb", "<cmd>Telescope dap list_breakpoints<cr>",                                    desc = "Dap Breakpoints" },
	{ "<leader>sdc", "<cmd>Telescope dap commands<cr>",                                            desc = "Dap Commands" },
	{ "<leader>sdf", "<cmd>Telescope dap frames<cr>",                                              desc = "Dap Frames" },
	{ "<leader>sdg", "<cmd>Telescope dap configurations<cr>",                                      desc = "Dap Configurations" },
	{ "<leader>sdv", "<cmd>Telescope dap variables<cr>",                                           desc = "Dap Variables" },
	{ "<leader>se",  "<cmd>Telescope frecency<cr>",                                                desc = "Frecency" },
	{ "<leader>sf",  "<cmd>Telescope find_files hidden=true<cr>",                                  desc = "Find File (CWD)" },
	{ "<leader>sg",  "<cmd>lua searchWithCurrentSelectedText()<cr>",                               desc = "Live grep fixed string" },
	{ "<leader>sh",  "<cmd>Telescope help_tags<cr>",                                               desc = "Find Help" },
	{ "<leader>sk",  "<cmd>Telescope keymaps<cr>",                                                 desc = "Keymaps" },
	{ "<leader>sl",  "<cmd>Telescope resume<cr>",                                                  desc = "Resume last search" },
	{ "<leader>so",  "<cmd>Telescope oldfiles<cr>",                                                desc = "Open Recent File" },
	{ "<leader>sp",  "<cmd>Telescope aerial<cr>",                                                  desc = "Areal Toggle" },
	{ "<leader>sr",  desc = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>" },
	{ "<leader>ss",  "<cmd>Telescope git_status<cr>",                                              desc = "Git status" },
	{ "<leader>sz",  "<cmd>Telescope zoxide list<cr>",                                             desc = "Zoxide" },

	{ "<leader>t",   group = "Tests" },
}
