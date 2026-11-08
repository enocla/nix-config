-- Utility tools and miscellaneous plugins

return {
    -- Snacks.nvim - Swiss army knife
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("plugins.configs.snacks")
        end,
    },

    -- Highlight yanks, changes, etc with animations
    {
        "rachartier/tiny-glimmer.nvim",
        event = "BufWritePre",
        config = function()
            require("tiny-glimmer").setup({
                overwrite = {
                    auto_map = true,
                    yank = {
                        enabled = true,
                        default_animation = { name = "fade", settings = { from_color = "RenderMarkdownH6Bg" } },
                    },
                    paste = {
                        enabled = true,
                        default_animation = { name = "fade", settings = { from_color = "RenderMarkdownH3Bg" } },
                    },
                    redo = {
                        enabled = true,
                        default_animation = { name = "fade", settings = { from_color = "RenderMarkdownH4Bg" } },
                    },
                    undo = {
                        enabled = true,
                        default_animation = { name = "fade", settings = { from_color = "RenderMarkdownH1Bg" } },
                    },
                },
                transparency_color = "#1d1f21",
                hijack_ft_disabled = { "snacks_dashboard" },
                virt_text = {
                    priority = 2048,
                },
            })
        end,
    },

    -- Color highlighting
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {
            filetypes = { "*" },
            user_default_options = {
                css = true,
                names = false,
                tailwind = true,
                mode = "virtualtext",
                virtualtext_inline = "before",
                virtualtext = "􀑌",
            },
        },
    },

    -- Peek line numbers
    {
        "nacro90/numb.nvim",
        opts = {},
        event = "VeryLazy",
    },

    -- Markdown rendering
    {
        "MeanderingProgrammer/render-markdown.nvim",
        event = "VeryLazy",
        opts = {
            heading = {
                width = "block",
                left_pad = 1,
                right_pad = 2,
                position = "inline",
            },
            code = {
                width = "block",
                left_pad = 2,
                right_pad = 2,
            },
        },
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        -- Queries are symlinked from the plugin and update with it, but compiled
        -- parsers don't; rebuild them on every plugin update so the two never
        -- drift apart (otherwise: "Query error ... Invalid node type").
        build = ":TSUpdate",
        config = function()
            require("plugins.configs.treesitter")
        end,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = 1000,
            preset = "modern",
            win = {
                border = "single",
                title = true,
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "MantleBorder" })
        end,
    },
}
