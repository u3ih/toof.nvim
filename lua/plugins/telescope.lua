return {
	{
		'nvim-telescope/telescope.nvim',
		cmd = 'Telescope',
		-- version = false,
		lazy = true,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'jvgrootveld/telescope-zoxide',
			'nvim-tree/nvim-web-devicons',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			'nvim-telescope/telescope-ui-select.nvim',
			'telescope-dap.nvim',
			'kkharji/sqlite.lua',
			'nvim-telescope/telescope-frecency.nvim',
			"olacin/telescope-cc.nvim"
			-- {
			--   "nvim-telescope/telescope-file-browser.nvim",
			--   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
			-- }
		},
		config = function()
			local telescope = require('telescope')
			local actions = require('telescope.actions')
			local trouble = require("trouble.providers.telescope")
			local z_utils = require("telescope._extensions.zoxide.utils")

			telescope.setup {
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<C-t>"] = trouble.open_with_trouble,
							['<C-u>'] = false,
							['<C-d>'] = false,
						},

						n = { ["<C-t>"] = trouble.open_with_trouble },
					},
					previewer = false,
					-- hidden = true,
					prompt_prefix = "   ",
					file_ignore_patterns = { "%.git/.", "node_modules", "package.json", "package-lock.json", "build", "dist", "yarn.lock", "next" },
					initial_mode = "insert",
					select_strategy = "reset",
					sorting_strategy = "ascending",
					-- layout_strategy = "horizontal",
					layout_config = {
						--   width = 0.5,
						--   height = 0.4,
						prompt_position = "top",
						preview_cutoff = 120,
					},
					path_display = {
						truncate = 3,
					}
				},
				pickers = {
					find_files = {
						-- theme = "dropdown",
						previewer = true,
						layout_config = {
							-- width = 0.5,
							height = 0.8,
							prompt_position = "top",
							preview_cutoff = 120,
						},
					},
					git_files = {
						previewer = true,
						layout_config = {
							height = 0.8,
							prompt_position = "top",
							preview_cutoff = 120,
						},
					},
					buffers = {
						mappings = {
							i = {
								["<c-d>"] = actions.delete_buffer,
							},
							n = {
								["<c-d>"] = actions.delete_buffer,
							},
						},
						previewer = false,
						initial_mode = "insert",
						theme = "dropdown",
						layout_config = {
							width = 0.5,
							height = 0.4,
							prompt_position = "top",
							preview_cutoff = 120,
						},
					},
					current_buffer_fuzzy_find = {
						previewer = true,
						-- theme = "dropdown",
						layout_config = {
							-- width = 0.5,
							height = 0.8,
							prompt_position = "top",
							preview_cutoff = 120,
						},
					},
					live_grep = {
						only_sort_text = true,
						previewer = true,
						-- additional_args = { "--fixed-strings" },
						layout_config = {
							horizontal = {
								width = 0.9,
								height = 0.75,
								preview_width = 0.6,
							},
						},
					},
					grep_string = {
						only_sort_text = true,
						previewer = true,
						layout_config = {
							horizontal = {
								width = 0.9,
								height = 0.75,
								preview_width = 0.6,
							},
						},
					},
					lsp_references = {
						show_line = false,
						previewer = true,
						layout_config = {
							horizontal = {
								width = 0.9,
								height = 0.75,
								preview_width = 0.6,
							},
						},
					},
					treesitter = {
						show_line = false,
						previewer = true,
						layout_config = {
							horizontal = {
								width = 0.9,
								height = 0.75,
								preview_width = 0.6,
							},
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,             -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					},
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							previewer        = false,
							initial_mode     = "normal",
							sorting_strategy = 'ascending',
							layout_strategy  = 'horizontal',
							layout_config    = {
								horizontal = {
									width = 0.5,
									height = 0.4,
									preview_width = 0.6,
								},
							},
						})
					},
					zoxide = {
						prompt_title = "[ Walking on the shoulders of TJ ]",
						mappings = {
							default = {
								after_action = function(selection)
									print("Update to (" .. selection.z_score .. ") " .. selection.path)
								end
							},
							["<C-s>"] = {
								before_action = function(selection) print("before C-s") end,
								action = function(selection)
									vim.cmd.edit(selection.path)
								end
							},
							-- Opens the selected entry in a new split
							["<C-q>"] = { action = z_utils.create_basic_command("split") },
						},
					},
					frecency = {
						default_workspace = 'CWD',
						show_scores = true,
						show_unindexed = true,
						disable_devicons = false,
						ignore_patterns = {
							"*.git/*",
							"*/tmp/*",
							"*/lua-language-server/*",
						},
					},
					conventional_commits = {
            theme = "ivy", -- custom theme
            action = function(entry)
                -- entry = {
                --     display = "feat       A new feature",
                --     index = 7,
                --     ordinal = "feat",
                --     value = feat"
                -- }
                vim.print(entry)
            end,
            include_body_and_footer = true, -- Add prompts for commit body and footer
        },
					-- file_browser = {
					--   -- theme = "",
					--   previewer = true,
					--   -- disables netrw and use telescope-file-browser in its place
					--   hijack_netrw = true,
					--   -- mappings = {
					--   --   ["i"] = {
					--   --     -- your custom insert mode mappings
					--   --   },
					--   --   ["n"] = {
					--   --     -- your custom normal mode mappings
					--   --   },
					--   -- },
					-- },
				}
			}
			telescope.load_extension('fzf')
			telescope.load_extension('ui-select')
			telescope.load_extension('refactoring')
			telescope.load_extension('dap')
			telescope.load_extension("zoxide")
			telescope.load_extension("frecency")
			telescope.load_extension("conventional_commits")
			-- telescope.load_extension("file_browser")
		end
	},
}
