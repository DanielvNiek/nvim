vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true
vim.o.autoread = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.diagnostic.config({virtual_lines = true})
-- vim.cmd.colorscheme("catppuccin")

-- Setup autocomplete
vim.api.nvim_create_autocmd("LspAttach",{
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client ~= nil and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

-- Install and configure snacks plugin
vim.pack.add({'https://github.com/folke/snacks.nvim'})
require("snacks").setup({
	picker = { enabled = true },
})

-- Setup keymaps
vim.g.mapleader = " "
vim.keymap.set("n", "<C-s>", ":w<CR>", {desc = "Save"})
vim.keymap.set("n", "<leader>q", ":qa<CR>", {desc = "Quit"})
vim.keymap.set("n", "<leader>w", ":bd<CR>", {desc = "Delete Buffer"})
vim.keymap.set("n", "<leader>x", ":tabclose<CR>", {desc = "Close Tab"})
vim.keymap.set("n", "<leader>[", ":bp<CR>", {desc = "Previous Buffer"})
vim.keymap.set("n", "<leader>]", ":bn<CR>", {desc = "Next Buffer"})
vim.keymap.set("i", "<C-space>", "<C-x><C-o>", { desc = "Trigger autocomplete" })

vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end,	{ desc = "Smart find files" })
vim.keymap.set("n", "<leader>f", function() Snacks.picker.files() end,   { desc = "Find files" })
vim.keymap.set("n", "<leader>g", function() Snacks.picker.grep() end,    { desc = "Grep" })
vim.keymap.set("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>r", function() Snacks.picker.recent() end,  { desc = "Recent files" })
vim.keymap.set("n", "<leader>h", function() Snacks.picker.help() end,    { desc = "Help pages" })
vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end,       { desc = "File explorer" })

-- Enable LSPs
vim.lsp.enable({'lua-language-server','ty'})

-- Highlight selection on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 150, visual = true })
	end,
})

-- Restore cursor to file position in previous editing session
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

