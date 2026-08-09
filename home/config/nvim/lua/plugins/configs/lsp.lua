-- Setup capabilities for LSP (used by blink.cmp)
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Folding configuration for nvim-ufo
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

local foldHandler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (" 󰁂 %d "):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, "MoreMsg" })
    return newVirtText
end

require("ufo").setup({
    fold_virt_text_handler = foldHandler,
})

vim.g.zig_fmt_parse_errors = 0

-- Common on_attach function
local on_attach = function(client, bufnr)
    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end

-- Defaults apply to every explicitly enabled server below.
vim.lsp.config("*", {
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Keep this list synchronized with the language servers installed through mise
-- or the system toolchain. Explicit enablement prevents stale tools from being
-- activated merely because their binaries exist on PATH.
vim.lsp.enable({
    "astro",
    "bashls",
    "biome",
    "clangd",
    "cssls",
    "denols",
    "eslint",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "pyright",
    "ruff",
    "rust_analyzer",
    "svelte",
    "tailwindcss",
    "vtsls",
    "vue_ls",
    "yamlls",
})

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "􀃰 ",
            [vim.diagnostic.severity.WARN] = "􀼳 ",
            [vim.diagnostic.severity.INFO] = "􁊇 ",
            [vim.diagnostic.severity.HINT] = "􀤘 ",
        },
    },
})
