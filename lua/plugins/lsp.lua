return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        templ = {},

        -- zls lives in ~/zig/bin (on PATH); don't let mason install a second one
        zls = { mason = false },

        tailwindcss = {
          -- NOTE: don't set `filetypes` here -- lspconfig's defaults already cover
          -- templ/astro/vue/js/ts as well as html/css/react. Use `filetypes_include`
          -- to add to them, `filetypes_exclude` to drop some.
          settings = {
            tailwindCSS = {
              includeLanguages = {
                templ = "html",
              },
            },
          },
        },
      },
    },
  },

  -- rust: LazyVim's lang.rust extra disables lspconfig's rust_analyzer and drives
  -- rust-analyzer through rustaceanvim, so settings belong here.
  -- (procMacro.enable is already true in the extra.)
  -- {
  --   "mrcjkb/rustaceanvim",
  --   opts = {
  --     server = {
  --       default_settings = {
  --         ["rust-analyzer"] = {
  --           rustfmt = {
  --             overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
