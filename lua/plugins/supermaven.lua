-- local api = require("supermaven-nvim.api")
--
-- api.start() -- starts supermaven-nvim
-- api.stop() -- stops supermaven-nvim
-- api.restart() -- restarts supermaven-nvim if it is running, otherwise starts it
-- api.toggle() -- toggles supermaven-nvim
-- api.is_running() -- returns true if supermaven-nvim is running
-- api.use_free_version() -- switch to the free version
-- api.use_pro() -- switch to the pro version
-- api.logout() -- log out of supermaven
-- api.show_log() -- show logs for supermaven-nvim
-- api.clear_log() -- clear logs for supermaven-nvim
return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({})
    local api = require("supermaven-nvim.api")
    api.use_free_version()
    api.toggle()
    vim.keymap.set("n", "<leader>a", function()
      api.toggle()
    end, { noremap = true, silent = true, desc = "Toggle Supermaven" })
  end,
}
