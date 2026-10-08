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
vim.o.completeopt = "menu,menuone,noinsert,fuzzy"

vim.lsp.enable({ 'lua-language-server', 'ty', 'gopls', 'rust-analyzer' })

-- Install and configure plugins
vim.pack.add({
	'https://github.com/folke/snacks.nvim',
	'https://github.com/nvim-tree/nvim-web-devicons',
})
require("snacks").setup({
	picker = { enabled = true },
})

-- Setup keymaps
vim.g.mapleader = " "
vim.keymap.set("i", "<C-space>", "<C-x><C-o>", { desc = "Trigger autocomplete" })
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>R", ":restart<CR>", { desc = "Restart" })
vim.keymap.set("n", "<leader>w", ":bd<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", '<leader>o', '<cmd>silent! execute "%bd|e#|bd#"<cr>', { desc = 'Delete other buffers' })
vim.keymap.set("n", "<leader>\\", ":set invwrap<CR>", { desc = 'Toggle wrap' })
vim.keymap.set({ "n", "v" }, '<leader>a', vim.lsp.buf.code_action, { desc = 'Code action' })
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
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })

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

-- Automatically close brackets
vim.keymap.set("i", "(", "()<Left>", { noremap = true })
vim.keymap.set("i", "[", "[]<Left>", { noremap = true })
vim.keymap.set("i", "{", "{}<Left>", { noremap = true })

-- Don't retype closing brackets
vim.keymap.set("i", ")", function()
	return vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == ")" and "<Right>" or ")"
end, { expr = true })
vim.keymap.set("i", "]", function()
	return vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == "]" and "<Right>" or "]"
end, { expr = true })
vim.keymap.set("i", "}", function()
	return vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1, 1) == "}" and "<Right>" or "}"
end, { expr = true })

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
