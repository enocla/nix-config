-- UI-related plugins
COLORS = require("theme.colors")

return {
	-- Colorschemes
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("plugins.configs.colorscheme")
		end,
	}, -- Icons
	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			require("tiny-devicons-auto-colors").setup({})
		end,
	},

	-- Dim inactive windows
	{
		"tadaa/vimade",
		opts = {
			recipe = { "default", { animate = false } },
			fadelevel = 0.2,
			checkinterval = 0,
			basebg = COLORS.surface0,
			blocklist = {
				default_block = function(win, current)
					-- current can be nil
					if (win.win_config.relative == "") and (current and current.win_config.relative ~= "") then
						return false
					end
					return true
				end,
			},
		},
	},

	-- Buffer tabs
	{
		"akinsho/bufferline.nvim",
		event = "BufAdd",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"rachartier/tiny-devicons-auto-colors.nvim",
			{ "tiagovla/scope.nvim", config = true },
		},
		config = function()
			require("plugins.configs.bufferline")
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		event = "UIEnter",
		dependencies = { "nvim-tree/nvim-web-devicons", "AndreM222/copilot-lualine" },
		config = function()
			require("plugins.configs.lualine")
		end,
	},

	-- Diagnostics
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = { auto_preview = true },
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "BufReadPost",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "classic",
				options = {
					use_icons_from_diagnostic = true,
					multiple_diag_under_cursor = true,
					show_all_diags_on_cursorline = true,
					enable_on_insert = true,
					multilines = {
						enabled = true,
						always_show = true,
					},
					format = function(diag)
						if diag.source then
							return diag.message .. " — " .. diag.source
						end
						return diag.message
					end,
				},
			})
			vim.diagnostic.config({ virtual_text = false })
		end,
	},

	-- Git diff view
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		config = function()
			require("diffview").setup({
				file_panel = {
					listing_style = "tree",
					win_config = {
						position = "right",
						width = 30,
						win_opts = {},
					},
				},
			})
		end,
	},

	-- Rainbow delimiters
	{
		"hiphish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufReadPost",
	},

	-- Modern UI components
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("plugins.configs.noice")
		end,
	},
}
