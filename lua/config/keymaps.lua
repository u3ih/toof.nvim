local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- [[ Basic Keymaps ]]

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

map("n", "J", "mzJ`z", opts)
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
-- quick jump diagnostic
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- paste over currently selected text without yanking it
-- p puts text after the cursor,
-- P puts text before the cursor.
map("v", "p", '"_dP')
map("v", "P", '"_dp')

-- Move line on the screen rather than by line in the file
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- quick jump in insert mode
map("i", "<C-l>", "<ESC>A", opts)
map("i", "<C-h>", "<ESC>I", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- undo
map({ "x", "n", "s" }, "<C-z>", ":u<cr>", { desc = "Undo" })
map("i", "<C-z>", "<C-o>:u<cr>", { desc = "Undo in insert mode" })

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

-- quickfix actions
map("n", "<leader>qf", "<cmd>lua vim.lsp.buf.code_action()<CR>")
