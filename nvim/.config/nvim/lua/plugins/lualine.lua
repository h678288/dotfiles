return {
	"nvim-lualine/lualine.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lazy = require("lazy.status")
		local util = require("plugins.lualine.lualine_functions")
		local colors = require("plugins.lualine.lualine_colors")

		require("lualine").setup({

			options = {
				disabled_filetypes = { "snacks_dashboard" },
				section_separators = "",
				component_separators = "",
				theme = colors.catppuccin,
			},

			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 3)
						end,
					},
				},
				lualine_b = {
					{
						"filename",
						path = 4,
						symbols = {
							modified = "",
							readonly = "",
							unnamed = "[No Name]",
							newfile = "󰝒",
						},
					},
				},
				lualine_c = {
					{
						"branch",
						icon = "󰘬",
						color = { fg = "#6e738d", bg = "#1E1E2E" },
						cond = util.hide,
					},
					{
						"diff",
						-- symbols = { added = " ", modified = " ", removed = " " },
						diff_color = {
							added = "LualineDiff",
							modified = "LualineDiff",
							removed = "LualineDiff",
						},
						cond = util.hide,
					},
				},
				lualine_x = {
					{
						require("noice").api.status.search.get,
						cond = require("noice").api.status.search.has or util.hide,
						color = { fg = "#6c7086" },
					},
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
						color = { fg = "#f2cdcd" },
					},
					{
						"diagnostics",
						update_in_insert = true,
						cond = util.hide,
					},
					{
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
						color = { fg = "#6c7086" },
					},
					{
						lazy.updates,
						cond = lazy.has_updates or util.hide,
						color = { fg = "#fab387", bg = "#1E1E2E" },
					},
					{
						util.lsp,
						color = { fg = "#6c7086", bg = "#1E1E2E" },
						cond = util.hide,
					},
				},
				lualine_y = {
					{
						"filetype",
						icon_only = true,
					},
				},
				lualine_z = {
					{
						util.space,
						padding = 0,
					},
					{
						"progress",
						icon = "",
						padding = 0,
					},
					{
						"location",
						padding = 0,
					},
					{
						util.space,
						padding = 0,
					},
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "progress", "location" },
				lualine_y = {},
				lualine_z = {},
			},

			-- tabline = {
			-- 	lualine_a = {
			-- 		{
			-- 			"buffers",
			-- 			symbols = {
			-- 				alternate_file = "",
			-- 			},
			-- 			filetype_names = {
			-- 				oil = "Oil",
			-- 			},
			-- 		},
			-- 	},
			-- 	lualine_b = {},
			-- 	lualine_c = {},
			-- 	lualine_x = {},
			-- 	lualine_y = {},
			-- 	lualine_z = {
			-- 		{
			-- 			util.close,
			-- 			on_click = function()
			-- 				vim.cmd([[:wq]])
			-- 			end,
			-- 			color = { bg = "#f38ba8" },
			-- 		},
			-- 	},
			-- },
		})
	end,
}
