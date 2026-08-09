-- LSP and completion plugins

return {
    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            require("plugins.configs.lsp")
        end,
    },
    {
        "Darazaki/indent-o-matic",
        opts = {
            max_lines = 2048,
            standard_widths = { 2, 4, 8 },
            skip_multiline = true,
        },
    },

    -- Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                ["_"] = { "trim_whitespace", "trim_newlines" },
                lua = { "stylua", stop_after_first = true },
                nix = { "nixfmt", "alejandra", stop_after_first = true },
                kotlin = { "ktfmt", stop_after_first = true },
                racket = { "raco_fmt" },
                go = { "goimports", "gofumpt", "gofmt", stop_after_first = true },
                javascript = { "prettierd", "prettier", "deno_fmt", stop_after_first = true },
                typescript = { "prettierd", "prettier", "deno_fmt", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", "deno_fmt", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", "deno_fmt", stop_after_first = true },
                svelte = { "prettierd", "prettier", stop_after_first = true },
                astro = { "prettierd", "prettier", stop_after_first = true },
                vue = { "prettierd", "prettier", stop_after_first = true },
                markdown = { "prettierd", "prettier", "deno_fmt", stop_after_first = true },
                json = { "prettierd", "prettier", "deno_fmt", stop_after_first = true },
                jsonc = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "prettierd", "prettier", stop_after_first = true },
                html = { "prettierd", "prettier", stop_after_first = true },
                css = { "prettierd", "prettier", stop_after_first = true },
                scss = { "prettierd", "prettier", stop_after_first = true },
                python = { "ruff_format", "black", "isort", stop_after_first = true },
                rust = { "rustfmt", stop_after_first = true },
                sh = { "shfmt", stop_after_first = true },
                bash = { "shfmt", stop_after_first = true },
                c = { "clang_format", stop_after_first = true },
                cpp = { "clang_format", stop_after_first = true },
                java = { "google-java-format", stop_after_first = true },
                ocaml = { "ocamlformat", stop_after_first = true },
                r = { "air", stop_after_first = true },
                zig = { "zls", stop_after_first = true },
            },
            formatters = {
                raco_fmt = {
                    command = "raco",
                    args = { "fmt", "-i", "$FILENAME" },
                    stdin = false,
                },
            },
        },
    },

    -- Completion
    {
        "saghen/blink.cmp",
        version = "*",
        build = "nix run .#build-plugin --accept-flake-config",
        event = "InsertEnter",
        dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot" },
        opts = {
            keymap = {
                preset = "default",
                ["<Tab>"] = { "accept", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
            },
            appearance = {
                nerd_font_variant = "normal",
            },
            completion = {
                menu = {
                    draw = {
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
                        treesitter = { "lsp" },
                    },
                    winhighlight = "Normal:CmpNormal,FloatBorder:CmpNormal,CursorLine:CmpSel,Search:None",
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                    window = {
                        border = "single",
                        winhighlight = "Normal:DocNormal,FloatBorder:CrustBorder",
                    },
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
        },
    },

    -- LSP utilities
    { "artemave/workspace-diagnostics.nvim", event = "VeryLazy" },
    { "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" }, event = "VeryLazy" },
    {
        "linrongbin16/lsp-progress.nvim",
        config = function()
            require("lsp-progress").setup({
                format = function(client_messages)
                    if #client_messages > 0 then
                        return table.concat(client_messages, " ")
                    end
                    return ""
                end,
            })
        end,
    },
}
