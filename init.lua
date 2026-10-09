vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true
vim.o.autoread = true
vim.o.scrolloff = 8
vim.o.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.diagnostic.config({ virtual_lines = true })
vim.o.completeopt = "menu,menuone,noinsert,fuzzy,popup"
vim.opt.colorcolumn = "101"

-- Only show cmd line on commands or macro recordings
vim.opt.cmdheight = 0
vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		vim.opt.cmdheight = 1
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function()
		vim.opt.cmdheight = 0
	end,
})


-- Install and configure plugins
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/b0o/SchemaStore.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
})
require("mason").setup()
require("snacks").setup({
	picker = { enabled = true },
	notifier = { enabled = true },
})
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
require('mini.pairs').setup()
require('lualine').setup({})

-- Setup tree sitters
-- Enable LSPs
vim.lsp.enable({
	"lua_ls",
	"ty",
	"gopls",
	"rust_analyzer",
	"zls",
	"yamlls",
	"jsonls",
	"dockerls",
})

-- Ensure mason packages are installed
local registry = require("mason-registry")
local mason_packages = {
	"lua-language-server",
	"ty",
	"gopls",
	"rust-analyzer",
	"zls",
	"yaml-language-server",
	"json-lsp",
	"dockerfile-language-server",
	"tree-sitter-cli"
}
registry.refresh(function()
	for _, pkg_name in ipairs(mason_packages) do
		local ok, pkg = pcall(registry.get_package, pkg_name)
		if ok then
			if not pkg:is_installed() then
				vim.notify("Installing mason package: " .. pkg_name, vim.log.levels.INFO)

				-- Triggers asynchronous installation in the background
				pkg:install({}, function(success, err)
					if not success then
						vim.notify("Failed to install " .. pkg_name .. ": " .. vim.inspect(err), vim.log.levels.ERROR)
					end
				end)
			end
		else
			vim.notify("Mason package not found: " .. pkg_name, vim.log.levels.ERROR)
		end
	end
end)

-- Setup tree sitter targets
local tree_sitter_targets = { "dockerfile", "go", "rust", "python", "zig", "yaml", "json" }
require("nvim-treesitter").install(tree_sitter_targets)
vim.o.foldlevel = 99
vim.api.nvim_create_autocmd("FileType", {
	pattern = tree_sitter_targets,
	callback = function()
		vim.treesitter.start()
		vim.wo[0][0].foldmethod = "expr"
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

-- Setup keymaps
vim.g.mapleader = " "
vim.keymap.set("i", "<C-space>", "<C-x><C-o>", { desc = "Trigger autocomplete" })
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>R", ":restart<CR>", { desc = "Restart" })
vim.keymap.set("n", "<leader>w", ":bd<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>m", ":Mason<CR>", { desc = "Mason" })
vim.keymap.set("n", "<leader>o", '<cmd>silent! execute "%bd|e#|bd#"<cr>', { desc = "Delete other buffers" })
vim.keymap.set("n", "<leader>\\", ":set invwrap<CR>", { desc = "Toggle wrap" })
vim.keymap.set("n", "n", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart find files" })
vim.keymap.set("n", "<leader>f", function() Snacks.picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>r", function() Snacks.picker.recent() end, { desc = "Recent files" })
vim.keymap.set("n", "<leader>?", function() Snacks.picker.help() end, { desc = "Help pages" })
vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "File explorer" })
vim.keymap.set("n", "<leader>g", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>l", ":checkhealth lsp<CR>", { desc = "LSP health" })
vim.keymap.set("n", "<leader>L", ":lsp restart<CR>", { desc = "LSP restart" })
vim.keymap.set("n", "<leader>h", function() Snacks.lazygit.log_file() end, { desc = "Lazygit file history" })
vim.keymap.set("n", "<leader>d", function() Snacks.picker.git_diff() end, { desc = "Git diff" })
vim.keymap.set("n", "<leader>k", function() Snacks.picker.keymaps() end, { desc = "View keymaps" })
vim.keymap.set("n", "<leader>s", function() Snacks.picker.lsp_symbols() end, { desc = "File LSP symbols" })
vim.keymap.set("n", "<leader>S", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace LSP symbols" })
vim.keymap.set("n", "<leader>C", function() Snacks.picker.colorschemes() end, { desc = "Workspace LSP symbols" })
vim.keymap.set("n", "<leader>!", function() Snacks.picker.notifications() end, { desc = "Notifications" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set('n', '<leader>n', vim.lsp.buf.rename, { desc = 'LSP rename symbol' })
vim.keymap.set('n', 'f', "za", { desc = 'Toggle fold' })
vim.keymap.set('n', 'F', "zR", { desc = 'Open all folds' })

-- Trigger autocomplete while typing
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client ~= nil and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

-- Autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- Highlight selection on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 150, visual = true })
	end,
})

-- Restore cursor location in file
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})
