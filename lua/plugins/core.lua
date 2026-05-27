return {
  {
    "LazyVim/LazyVim",
    opts = {
      kind_filter = {
        default = {
          "Constant",
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Package",
          "Property",
          "Struct",
          "Trait",
        },
        markdown = false,
        help = false,
        -- you can specify a different filter for each filetype
        lua = {
          "Class",
          "Constructor",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          -- "Package", -- remove package since luals uses it for control flow structures
          "Property",
          "Struct",
          "Trait",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
  --[blink should not auto trigger]
  -- {
  --   "saghen/blink.cmp",
  --   opts = {
  --     -- sources = {
  --     --   providers = {
  --     --     copilot = {
  --     --       name = "copilot",
  --     --       -- Set this value to your desired priority
  --     --       score_offset = -1000,
  --     --       async = true,
  --     --     },
  --     --     -- other providers like lsp, path, snippets, buffer...
  --     --   },
  --     -- },
  --     completion = {
  --       --[copilot weight must be lowest possible]
  --       ghost_text = {
  --         enabled = false,
  --       },
  --       trigger = {
  --         -- When true, will prefetch the completion items when entering insert mode
  --         prefetch_on_insert = true,
  --
  --         -- When false, will not show the completion window automatically when in a snippet
  --         show_in_snippet = true,
  --
  --         -- When true, will show completion window after backspacing
  --         show_on_backspace = false,
  --
  --         -- When true, will show completion window after backspacing into a keyword
  --         show_on_backspace_in_keyword = false,
  --
  --         -- When true, will show the completion window after accepting a completion and then backspacing into a keyword
  --         show_on_backspace_after_accept = false,
  --
  --         -- When true, will show the completion window after entering insert mode and backspacing into keyword
  --         show_on_backspace_after_insert_enter = false,
  --
  --         -- When true, will show the completion window after typing any of alphanumerics, `-` or `_`
  --         show_on_keyword = false,
  --
  --         -- When true, will show the completion window after typing a trigger character
  --         show_on_trigger_character = true,
  --
  --         -- When true, will show the completion window after entering insert mode
  --         show_on_insert = false,
  --
  --         -- LSPs can indicate when to show the completion window via trigger characters
  --         -- however, some LSPs (i.e. tsserver) return characters that would essentially
  --         -- always show the window. We block these by default.
  --         show_on_blocked_trigger_characters = { " ", "\n", "\t" },
  --         -- You can also block per filetype with a function:
  --         -- show_on_blocked_trigger_characters = function(ctx)
  --         --   if vim.bo.filetype == 'markdown' then return { ' ', '\n', '\t', '.', '/', '(', '[' } end
  --         --   return { ' ', '\n', '\t' }
  --         -- end,
  --
  --         -- When both this and show_on_trigger_character are true, will show the completion window
  --         -- when the cursor comes after a trigger character after accepting an item
  --         show_on_accept_on_trigger_character = false,
  --
  --         -- When both this and show_on_trigger_character are true, will show the completion window
  --         -- when the cursor comes after a trigger character when entering insert mode
  --         show_on_insert_on_trigger_character = false,
  --
  --         -- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
  --         -- the completion window when the cursor comes after a trigger character when
  --         -- entering insert mode/accepting an item
  --         show_on_x_blocked_trigger_characters = { "'", '"', "(" },
  --         -- or a function, similar to show_on_blocked_trigger_character
  --       },
  --     },
  --   },
  -- },
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 1,
            },
          },
          position = "left",
          size = 0.4,
        },
        {
          elements = {
            {
              id = "repl",
              size = 1,
            },
          },
          position = "bottom",
          size = 0.4,
        },
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          style = "terminal", -- or "terminal" for a split window
          width = math.floor(vim.o.columns * 0.4), -- sets width to 40% of screen columns
          height = 5,
          wo = {
            winbar = "",
          },
          position = "right",
        },
      },
    },
  },
}
