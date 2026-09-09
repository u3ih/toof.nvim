-- Disable expensive features (LSP, treesitter, syntax, ...) on big files
return {
  'LunarVim/bigfile.nvim',
  event = { 'FileReadPre', 'BufReadPre' },
  opts = {
    filesize = 1,      -- MiB, rounded to nearest MiB
    pattern = { '*' }, -- autocmd pattern, or a function returning true for "big"
    features = {
      'indent_blankline',
      'illuminate',
      'lsp',
      'treesitter',
      'syntax',
      'matchparen',
      'vimopts',
      'filetype',
    },
  },
}
