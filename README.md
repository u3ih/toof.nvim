# hieuchan/nvim

Personal Neovim configuration built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), extended into a full multi-file setup.

## Structure

```
~/.config/nvim/
├── init.lua                          # Entry point — loads config modules
├── lua/
│   ├── config/
│   │   ├── options.lua               # Vim options (tabs, numbers, clipboard, etc.)
│   │   ├── keymaps.lua               # Global keymaps
│   │   ├── autocmd.lua               # Autocommands
│   │   ├── lazy.lua                  # lazy.nvim bootstrap
│   │   ├── colors.lua                # Color overrides
│   │   └── which-key/
│   │       ├── defaults.lua          # Leader key groups
│   │       └── non_leader.lua        # Non-leader key groups
│   ├── plugins/                      # One file per plugin
│   │   ├── lsp-zero.lua              # LSP (mason + lspconfig + lsp-zero)
│   │   ├── nvim-cmp.lua              # Completion
│   │   ├── nvim-treesitter.lua       # Syntax / highlighting
│   │   ├── telescope.lua             # Fuzzy finder
│   │   ├── neo-tree.lua              # File explorer
│   │   ├── oil-nvim.lua              # File manager (buffer-style)
│   │   ├── bufferline.lua            # Buffer tabs
│   │   ├── lualine.lua               # Status line
│   │   ├── noice.lua                 # UI overhaul (cmdline, messages)
│   │   ├── dropbar.lua               # Breadcrumb bar
│   │   ├── gitsigns.lua              # Git hunk signs
│   │   ├── lazygit.lua               # LazyGit integration
│   │   ├── git-diffview.lua          # Diff / merge tool
│   │   ├── conform.lua               # Formatting (prettier, etc.)
│   │   ├── nvim-dap.lua              # Debugger
│   │   ├── trouble.lua               # Diagnostics list
│   │   ├── telescope.lua             # Fuzzy finder
│   │   ├── nvim-spectre.lua          # Project-wide search/replace
│   │   ├── refactoring.lua           # Refactoring tools
│   │   ├── react-extract.lua         # React component extraction
│   │   ├── copilot.lua               # GitHub Copilot
│   │   ├── claude-code.lua           # Claude Code integration
│   │   ├── codecompanion.lua         # CodeCompanion AI
│   │   ├── chatgpt.lua               # ChatGPT integration
│   │   ├── gemini-ai.lua             # Gemini AI integration
│   │   ├── colorschemes.lua          # Theme plugins
│   │   ├── transparent.lua           # Transparency support
│   │   ├── indent-blankline.lua      # Indent guides
│   │   ├── nvim-autopairs.lua        # Auto brackets
│   │   ├── nvim-surround.lua         # Surround motions
│   │   ├── comments.lua              # Comment toggling
│   │   ├── which-key.lua             # Keymap hints
│   │   ├── nvim-alpha.lua            # Dashboard / start screen
│   │   ├── persistance.lua           # Session persistence
│   │   ├── undotree.lua              # Undo history tree
│   │   ├── snippers.lua              # Snippets
│   │   ├── nvim-tmux-navigation.lua  # Tmux pane navigation
│   │   ├── render-markdown.lua       # Markdown rendering
│   │   ├── codesnap.lua              # Code screenshot
│   │   ├── precognition.lua          # Motion hints
│   │   ├── nvim-leetcode.lua         # LeetCode in Neovim
│   │   ├── exercism.lua              # Exercism integration
│   │   └── ...
│   └── utils/
│       ├── init.lua                  # Shared utilities
│       ├── icons.lua                 # Icon sets
│       ├── lsp-utils.lua             # LSP helpers (Go test toggle, etc.)
│       └── snippets.lua              # Snippet definitions
└── lazy-lock.json                    # Plugin lockfile
```

## LSP

Managed via `lsp-zero` v3 + `mason` + `mason-lspconfig`.

| Language | Server |
| :-- | :-- |
| TypeScript / JavaScript | `ts_ls` |
| Lua | `lua_ls` |
| Rust | `rust_analyzer` (clippy checks) |
| CSS | `cssls` |
| JSON | `jsonls` + schemastore |
| Tailwind | `tailwindcss` |
| Python | `pylsp` |
| ESLint | `eslint@4.8.0` |

Formatter: `prettier` via `conform.nvim`.

> **Node requirement:** `ts_ls` and `eslint` use Node v24.2.0 via nvm. Install with:
> ```sh
> nvm install 24.2.0
> ```

## Key Bindings

`<Space>` is leader.

| Key | Action |
| :-- | :-- |
| `<S-l>` / `<S-h>` | Next / prev buffer |
| `<C-s>` | Save file |
| `<C-z>` | Undo |
| `<C-d>` / `<C-u>` | Scroll down/up (centered) |
| `J` / `K` (visual) | Move block up/down |
| `<` / `>` (visual) | Indent (stay in visual) |
| `p` / `P` (visual) | Paste without yanking selection |
| `d` / `D` (visual) | Delete without yanking |
| `X` | Split line at cursor |
| `+` / `_` | Resize vertical split |
| `=` / `-` | Resize horizontal split |
| `<leader>v` | VSplit + go to definition |
| `<leader>qf` | Code action |
| `<leader>cfn` / `<leader>cfp` | Copy filename / filepath |
| `gd` / `gD` | Go to definition / declaration |
| `gr` | References (Telescope) |
| `gi` | Implementations (Telescope) |
| `K` | Hover docs |
| `<F2>` | Rename symbol |
| `<F3>` | Format buffer |
| `<F4>` | Code action |
| `[d` / `]d` | Prev / next diagnostic |

## Requirements

- Neovim stable or nightly
- `ripgrep` — Telescope live grep
- `fd` — Telescope file finder
- `node` v24.2.0 via nvm — `ts_ls`, `eslint`
- `git` — gitsigns, lazygit, diffview
- A [Nerd Font](https://www.nerdfonts.com/) for icons

## Installation

```sh
# Back up existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone <your-repo-url> ~/.config/nvim

# Start Neovim — lazy.nvim installs plugins automatically
nvim
```
