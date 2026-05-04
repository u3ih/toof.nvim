return {
	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {},
	},
	{
		'numToStr/Comment.nvim',
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring"
		},
		config = function()
			vim.o.commentstring = '# %s'

			require('ts_context_commentstring').setup({
				enable_autocmd = false,
			})

			require('Comment').setup({
				pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
			})
		end
	},
}
