return {
	{
		'folke/todo-comments.nvim',
		event = "VeryLazy",
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	-- "gc" to comment visual regions/lines
	{ 
		'numToStr/Comment.nvim', 
		opts = {},
		event = "VeryLazy",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring"
		},
		config = function()
			require('Comment').setup({
				pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
			})
			require('ts_context_commentstring').setup {
			  enable_autocmd = false,
			}
		end
	},
}
