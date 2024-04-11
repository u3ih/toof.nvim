return {
  'u3ih/gemini.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  enabled = false,
  opts = {
    api_key = os.getenv('GEMINI_API_KEY'), -- or read from env: `os.getenv('GEMINI_API_KEY')`
    -- The locale for the content to be defined/translated into
    locale = 'en',
    -- The locale for the content in the locale above to be translated into
    alternate_locale = 'vi',
    -- Gemini's answer is displayed in a popup buffer
    -- Default behaviour is not to give it the focus because it is seen as a kind of tooltip
    -- But if you prefer it to get the focus, set to true.
    result_popup_gets_focus = true,
    -- Define custom prompts here, see below for more details
    prompts = {},
  },
  event = 'VeryLazy',
}
