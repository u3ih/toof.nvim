local home = vim.fn.expand("$HOME")

return {
  "jackMort/ChatGPT.nvim",
  -- chatgpt need account api key paid to query :<
  enabled = false,
  event = "VeryLazy",
  config = function()
    require("chatgpt").setup({
      api_key_cmd = "gpg --decrypt " .. home .. "/secret.txt.gpg"
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim"
  }
}
