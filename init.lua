-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

--[set text width to 80 for markdown and 120 for go]--
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = "81"
    vim.opt_local.wrap = true
  end,
})
vim.opt.colorcolumn = "101"

-- LSP servers are configured in lua/plugins/ (LazyVim owns the server specs):
--   yamlls                     -> lua/plugins/yaml.lua
--   templ, zls, tailwindcss,
--   rust-analyzer              -> lua/plugins/lsp.lua
--
-- Do NOT call require("lspconfig").<server>.setup() here. That is the deprecated
-- lspconfig framework; it starts a *second* client next to LazyVim's, and that
-- second client only ever attaches to the first buffer of that filetype you open.

vim.filetype.add({ extension = { templ = "templ" } })
