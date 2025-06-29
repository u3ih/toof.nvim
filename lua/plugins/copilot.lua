return {
	{
		"zbirenbaum/copilot.lua",
		enabled = true,
		cmd = "Copilot",
		event = "InsertEnter",
		dependencies = {
			{
				"CopilotC-Nvim/CopilotChat.nvim",
				dependencies = {
					{ "zbirenbaum/copilot.lua" },              -- or github/copilot.vim
					{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
				},
				build = "make tiktoken",                     -- Only on MacOS or Linux
				keys = {
					{ "<Leader>cc", "<cmd>CopilotChat<cr>",        desc = "Copilot Chat" },
					{ "<Leader>cs", "<cmd>CopilotChatSubmit<cr>",  desc = "Copilot Chat Submit" },
					{ "<Leader>cR", "<cmd>CopilotChatReset<cr>",   desc = "Copilot Chat Reset" },
					{ "<Leader>cl", "<cmd>CopilotChatLoad<cr>",    desc = "Copilot Chat Load" },
					{ "<Leader>cp", "<cmd>CopilotChatPrompts<cr>", desc = "Copilot Chat Prompts" },
					{ "<Leader>cm", "<cmd>CopilotChatModels<cr>",  desc = "Copilot Chat Models" },
					{ "<Leader>ca", "<cmd>CopilotChatAgents<cr>",  desc = "Copilot Chat Agents" },
					{ "<Leader>cS", "<cmd>CopilotChatSave<cr>",    desc = "Copilot Chat Save" },
					{ "<Leader>cC", "<cmd>CopilotChatClose<cr>",   desc = "Copilot Chat Close" },
					{ "<Leader>cT", "<cmd>CopilotChatToggle<cr>",  desc = "Copilot Chat Toggle" },
					{ "<Leader>cO", "<cmd>CopilotChatOpen<cr>",    desc = "Copilot Chat Open" },
					{ "<Leader>cP", "<cmd>CopilotChatStop<cr>",    desc = "Copilot Chat Stop" },
				},
				opts = {
					-- See Configuration section for options
					mappings = {
						close = {
							normal = 'q',
							insert = '<c-q>',
						},
					},
					debug = false,
				},
				mappings = {
					submit_prompt = {
						normal = '<Leader>s',
						insert = '<C-s>'
					},
				}
				-- See Commands section for default commands if you want to lazy load on them
			},
		},
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false,
					auto_refresh = true,
					keymap = {
						jump_next = "<c-j>",
						jump_prev = "<c-k>",
						accept = "<c-]>",
						refresh = "<leader>f5",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4,
					},
				},
				copilot_node_command = vim.fn.expand("$HOME") .. "/.nvm/versions/node/v20.8.1/bin/node", -- fix node version for copilot
				suggestion = {
					enabled = false,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<c-]>",
						accept_word = false,
						accept_line = false,
						next = "<c-j>",
						prev = "<c-k>",
						dismiss = "<C-e>",
					},
				},
			})
		end,
	},
}
