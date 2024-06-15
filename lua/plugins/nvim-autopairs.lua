return {
	'windwp/nvim-autopairs',
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup {}
	end,
	-- use opts = {} for passing setup options
	-- this is equalent to setup({}) function
	opts = {
		enable_check_bracket_line = true
	},
}
