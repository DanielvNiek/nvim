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

require("lspconfig").yamlls.setup({
  settings = {
    yaml = {
      schemas = {
        kubernetes = "*.yml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
      },
    },
  },
})

vim.filetype.add({ extension = { templ = "templ" } })
-- Define a minimal on_attach function, necessary for the lspconfig setups below
local on_attach = function(client, bufnr)
  -- You can add keybindings here, e.g.,
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
  print("LSP attached: " .. client.name)
end

-- blink.cmp uses native Neovim LSP capabilities, so we use the built-in function
local capabilities = vim.lsp.protocol.make_client_capabilities()
local lspconfig = require("lspconfig")

-- LSP Configs (unchanged from original, using the new 'capabilities' variable)
lspconfig.templ.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.tailwindcss.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "templ", "astro", "javascript", "typescript", "vue" },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        templ = "html",
      },
    },
  },
})
