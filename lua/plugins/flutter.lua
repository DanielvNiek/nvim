return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
  -- in neotest-dart.lua
  {
    "sidlatau/neotest-dart",
    dependencies = {
      "nvim-neotest/neotest",
    },
    lazy = false,
  },
}
