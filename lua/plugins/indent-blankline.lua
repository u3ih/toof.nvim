-- local highlight = {
--   "WhiteSpace",
-- }
local highlight = {
  "RainbowYellow",
  "RainbowOrange",
  "RainbowBlue",
  "RainbowCyan",
}

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  enabled = true,
  main = "ibl",
  config = function()
    local hooks = require "ibl.hooks"
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)
    vim.g.rainbow_delimiters = { highlight = highlight }
    require('ibl').setup {
      indent = {
        -- highlight = highlight,
        -- char = "▏",
        char = "┊",
        -- char = "│",
        smart_indent_cap = true,
      },
      scope = { highlight = highlight }
    }
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
  end
}
