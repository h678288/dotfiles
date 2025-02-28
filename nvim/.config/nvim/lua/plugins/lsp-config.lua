return {
	{
		"williamboman/mason-nvim-dap.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			event = "VeryLazy",
			config = function()
				local mason = require("mason")
				local mason_lspconfig = require("mason-lspconfig")
				mason.setup({
					ui = {
						icons = {
							package_installed = "",
							package_pending = "",
							package_uninstalled = "",
						},
					},
					ensure_installed = {
						"clangd",
						"clang-format",
						"codelldb",
					},
				})
				mason_lspconfig.setup({
					ensure_installed = {
						"ts_ls",
						"html",
						"cssls",
						"clangd",
						"lua_ls",
						"emmet_ls",
						"hyprls",
					},
					automatic_installation = true,
				})
			end,
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "VeryLazy", "BufReadPre", "BufNewFile" },
		dependencies = {
			"Saghen/blink.cmp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/lazydev.nvim", opts = {} },
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")

			local lspconfig = require("lspconfig")

			local keymap = vim.keymap.set

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }
					-- LSP keymaps
					keymap("n", "K", vim.lsp.buf.hover, opts)
					keymap("n", "gD", vim.lsp.buf.declaration, opts)
					opts.desc = "Lsp rename"
					keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
					opts.desc = "Code actions"
					keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)

					-- opts.desc = "Lsp references"
					-- keymap("n", "<leader>cr", telescope.lsp_references, opts)
					-- opts.desc = "Lsp implementations"
					-- keymap("n", "<leader>ci", telescope.lsp_implementations, opts)
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- omnisharp setup
			local pid = vim.fn.getpid()
			local omnisharp_bin = "/home/magnus/.local/share/nvim/mason/bin/omnisharp"

			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["omnisharp"] = function()
					lspconfig["omnisharp"].setup({
						capabilities = capabilities,
						cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
					})
				end,
				["clangd"] = function()
					lspconfig["clangd"].setup({
						capabilities = capabilities,
						init_options = {
							fallbackFlags = { "-std=c++23" },
						},
					})
				end,
				["emmet_ls"] = function()
					lspconfig["emmet_ls"].setup({
						capabilities = capabilities,
						filetypes = {
							"html",
							"typescriptreact",
							"javascriptreact",
							"css",
							"sass",
							"scss",
							"less",
							"svelte",
						},
					})
				end,
				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							lua = {
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				end,
			})
		end,
	},
}
