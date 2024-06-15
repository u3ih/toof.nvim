local jsOrTs = {
	{
		type = 'node2',
		name = 'Launch',
		request = 'launch',
		program = '${file}',
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = 'inspector',
		console = 'integratedTerminal',
	},
	{
		type = 'node2',
		name = 'Attach',
		request = 'attach',
		program = '${file}',
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = 'inspector',
		console = 'integratedTerminal',
	},
	{
		name = "Vitest Debug",
		type = "pwa-node",
		request = "launch",
		cwd = vim.fn.getcwd(),
		program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
		args = { "run", "${file}" },
		autoAttachChildProcesses = true,
		smartStep = true,
		console = "integratedTerminal",
		skipFiles = { "<node_internals>/**", "node_modules/**" },
	},
}

local chrome_debugger = {
	type = "pwa-chrome",
	request = "launch",
	name = "Chrome",
	webRoot = "${workspaceFolder}",
}

return {
	"mfussenegger/nvim-dap",
	lazy = true,
	enabled = true,
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
			-- stylua: ignore
			keys = {
				{ "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
				{ "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
			},
		},
		"theHamsta/nvim-dap-virtual-text",
		"nvim-telescope/telescope-dap.nvim",
		"folke/neodev.nvim",
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = "mason.nvim",
			cmd = { "DapInstall", "DapUninstall" },
			opts = {
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_installation = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					"node2",
					"js"
				},
			},
		}
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local virtual_text = require("nvim-dap-virtual-text")
		dapui.setup();
		virtual_text.setup({})


		dap.adapters.node2 = {
			type = 'executable',
			command = 'node',
			args = { vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
		}

		dap.configurations = {
			javascript = jsOrTs,
			typescript = jsOrTs,
			javascriptreact = chrome_debugger,
			typescriptreact = chrome_debugger,
		}

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter", -- Path to VSCode Debugger
				args = { "${port}" },
			}
		}

		dap.configurations.javascript = dap.configurations.typescript
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({ reset = true })
		end
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
		vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
		vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
		vim.keymap.set('n', '<F5>', require 'dap'.continue)
		vim.keymap.set('n', '<F10>', require 'dap'.step_over)
		vim.keymap.set('n', '<F11>', require 'dap'.step_into)
		vim.keymap.set('n', '<F12>', require 'dap'.step_out)
	end
}
