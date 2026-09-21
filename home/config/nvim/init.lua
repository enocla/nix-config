-- Enable Neovim loader for faster startup
vim.loader.enable()

-- Keep the generated palette outside the live checkout. Existing plugins can
-- continue to use require("theme.colors") through this compatibility module.
local function load_theme_colors()
    local data_home = vim.env.XDG_DATA_HOME or (vim.env.HOME .. "/.local/share")
    local path = data_home .. "/nix-config/theme-colors.json"
    local ok, contents = pcall(vim.fn.readfile, path)
    if ok then
        local decoded_ok, colors = pcall(vim.json.decode, table.concat(contents, "\n"))
        if decoded_ok then
            return colors
        end
    end

    -- The checkout remains a supported editable fallback for older generations.
    return dofile(vim.fn.stdpath("config") .. "/lua/theme/colors.lua")
end

package.preload["theme.colors"] = load_theme_colors

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- Load configuration
require("config")

-- Load plugins
require("plugins")

-- Load keymaps
require("mappings")
