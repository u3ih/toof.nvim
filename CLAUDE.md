# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Formatting

Lua files are formatted with `stylua`. Config is in `.stylua.toml`:
- 2-space indent, single quotes preferred, 160 column width, no call parentheses on single-arg calls.

Format a file:
```sh
stylua lua/path/to/file.lua
```

Check all Lua files:
```sh
stylua --check lua/
```

## Architecture

**Entry point:** `init.lua` loads four modules in order: `config.options` → `config.lazy` → `config.autocmd` → `config.keymaps`.

**Plugin loading:** `config/lazy.lua` bootstraps lazy.nvim and calls `require("lazy").setup("plugins", ...)`. lazy.nvim auto-discovers every file under `lua/plugins/` — one plugin spec (or table of specs) per file.

**Plugin spec pattern:** Each `lua/plugins/*.lua` returns a table accepted by lazy.nvim. Multi-plugin files (e.g. `lsp-zero.lua`) return a list of tables.

**Shared utilities** live in `lua/utils/`:
- `icons.lua` — single source of truth for all Nerd Font / emoji icons used across plugins (diagnostics, git, LSP kinds, DAP).
- `lsp-utils.lua` — helper functions called from keymaps and which-key: `toggle_go_test`, `toggle_inlay_hints`, `toggle_set_color_column`, `telescope_git_or_file`, `jumpable`.
- `snippets.lua` — LuaSnip snippet definitions.

**Keybinding layers:**
1. `config/keymaps.lua` — raw `vim.keymap.set` bindings (navigation, window resize, buffer switching).
2. `lua/config/which-key/defaults.lua` — leader-key groups registered with which-key (git, LSP, search, debug, replace, sessions, etc.).
3. `lua/config/which-key/non_leader.lua` — non-leader which-key bindings.
4. Per-plugin keymaps inside each plugin's `config` / `on_attach`.

**LSP setup** (`lua/plugins/lsp-zero.lua`):
- Uses `lsp-zero` v3 as glue between `mason`, `mason-lspconfig`, and `nvim-lspconfig`.
- `ts_ls` and `eslint` require Node **v24.2.0** at `~/.nvm/versions/node/v24.2.0/bin/node` — hardcoded path.
- `rust_analyzer` configured with clippy checks and proc-macro support.
- Duplicate `ts_ls` clients on the same buffer are killed via the `dedupe_ts` helper.

**Color/float overrides** applied on every `ColorScheme` event in `config/autocmd.lua` — `NormalFloat`, `FloatBorder`, `NormalNC` are forced to `guibg=none`.

## Project structure rules

Follow this placement strictly — lazy.nvim's auto-discovery depends on it:

| What | Where |
| :-- | :-- |
| New plugin | `lua/plugins/<name>.lua` |
| Shared helper / utility | `lua/utils/` |
| Vim options, autocmds, global keymaps | `lua/config/` |
| Leader-key groups | `lua/config/which-key/defaults.lua` |
| Non-leader key groups | `lua/config/which-key/non_leader.lua` |
| Icons | `lua/utils/icons.lua` (single source — don't hardcode elsewhere) |

Never place Lua modules at the repo root. `init.lua` is the only Lua file there.

## Adding a plugin

Create `lua/plugins/<name>.lua` returning a valid lazy.nvim spec. lazy.nvim picks it up automatically on next start. No registration step needed.

## README update policy

Update `README.md` when making these changes:

| Change | README section to update |
| :-- | :-- |
| Add or remove a plugin | Structure table under `lua/plugins/` |
| Add/remove/change an LSP server | LSP table |
| Add new leader or global keymap | Key Bindings table |
| Add new system requirement | Requirements list |

Skip README updates for internal refactors (renaming variables, reformatting, changing option values) that don't affect what the user installs or how they interact with the editor.

## Node version requirement

`ts_ls` and `eslint-lsp` launch via hardcoded absolute path:
```
~/.nvm/versions/node/v24.2.0/bin/node
```
If that path is missing, both servers fail silently with an `ERROR` notification. Install with:
```sh
nvm install 24.2.0
```
