local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- [[ Basic Keymaps ]]

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
		file_ignore_patterns = {
			"node_modules", "build", "dist", "yarn.lock", "next",
		},
	},
}

map('n', '<leader>fe', "<Cmd>EslintFixAll<CR>", { desc = 'Fix Eslint' })

-- See `:help telescope.builtin`
map('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
map('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- paste over currently selected text without yanking it
-- p puts text before the cursor,
-- P puts text after the cursor.
map("v", "p", '"_dP')
map("v", "P", '"_dp')

-- Move line on the screen rather than by line in the file
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- quick jump in insert mode
map("i", "<C-l>", "<ESC>A", opts)
map("i", "<C-h>", "<ESC>I", opts)
map({ 'n', 'x', 'o' }, '<C-h>', '^', opts)
map({ 'n', 'x', 'o' }, '<C-l>', '$', opts)

-- Exit on jj and jk
map("i", "jj", "<ESC>", opts)
map("i", "jk", "<ESC>", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Panes resizing
map("n", "+", ":vertical resize +5<CR>")
map("n", "_", ":vertical resize -5<CR>")
map("n", "=", ":resize +5<CR>")
map("n", "-", ":resize -5<CR>")

-- Map enter to ciw in normal mode
map("n", "<CR>", "ciw", opts)

-- map ; to resume last search
-- map("n", ";", "<cmd>Telescope resume<cr>", opts)

-- Split line with X
map('n', 'X', ':keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>', { silent = true })

-- Select all
-- map('n', '<C-a>', 'ggVGy', opts)

-- delete forward
-- w{number}dw
-- delete backward
-- w{number}db

map('n', '<C-P>', ':lua require("config.utils").toggle_go_test()<CR>', opts)
