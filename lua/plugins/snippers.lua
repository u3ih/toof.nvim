return {
	'L3MON4D3/LuaSnip',
	lazy = true,
	config = function()
		local ls = require('luasnip')
		local types = require('luasnip.util.types')

		ls.config.setup({
			history = true,
			updateevents = 'TextChanged,TextChangedI',
			enable_autosnippets = true,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { ' Current choice', 'NonText' } },
					}
				},
			},
		})

		ls.filetype_extend('javascript', { 'jsdoc' })
		ls.filetype_extend('javascript', { 'tsdoc' })
		ls.filetype_extend('javascript', { 'luadoc' })

		require('utils.snippets')
	end,
}
