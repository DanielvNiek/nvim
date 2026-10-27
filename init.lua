vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true
vim.o.autoread = true
vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.diagnostic.config({ virtual_lines = true })
vim.o.completeopt = "menu,menuone,noinsert,fuzzy,popup"
vim.opt.colorcolumn = "101"
vim.cmd("set ignorecase")
vim.cmd("set smartcase")

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
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/saecki/crates.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/jake-stewart/multicursor.nvim",
	"https://github.com/dawidd6/nvim-sops",
	"https://github.com/akinsho/bufferline.nvim",
})
require("mason").setup()
require("snacks").setup({
	picker = { enabled = true },
	notifier = { enabled = true },
})
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
require('mini.pairs').setup()
require('mini.files').setup({
	content = {
		filter = nil,
	},
	mappings = {
		go_in      = 'l',  -- Open file/directory and close the explorer
		go_in_plus = '<CR>', -- Open file/directory and keep the explorer open
	},
})
require('gitsigns').setup({})
require('crates').setup({
	lsp = {
		enabled = true,
		actions = true,
		completion = true,
		hover = true,
	},
})
local sops = require('sops')
sops.auto_edit = false
sops.setup()
local mc = require("multicursor-nvim")
mc.setup()
require('bufferline').setup({
	options = {
		diagnostics = 'nvim_lsp',
		separator_style = '',
		diagnostics_indicator = function(count, level)
			local icon = level:match('error') and ' ' or ' '
			return icon .. count
		end,
	},
})

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
	"taplo",
	"html",
	"cssls",
	"bashls",
	"buf_ls",
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
	"tree-sitter-cli",
	"taplo",
	"css-lsp",
	"html-lsp",
	"bash-language-server",
	"buf",
}
registry.refresh(function()
	for _, pkg_name in ipairs(mason_packages) do
		local ok, pkg = pcall(registry.get_package, pkg_name)
		if ok then
			if not pkg:is_installed() then
				vim.notify("Installing mason package: " .. pkg_name, vim.log.levels.INFO)
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
local tree_sitter_targets = { "lua", "dockerfile", "go", "rust", "python", "zig", "yaml", "json" }
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
local mapkey = vim.keymap.set
mapkey('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
mapkey('n', '<C-l>', '<C-w>l', { desc = 'Go to left window' })
mapkey("i", "<C-space>", "<C-x><C-o>", { desc = "Trigger autocomplete" })
mapkey("n", "<C-s>", ":w<CR>", { desc = "Save" })
mapkey("n", "<leader>q", ":qa<CR>", { desc = "Quit" })
mapkey("n", "<leader>R", ":restart<CR>", { desc = "Restart" })
mapkey("n", "<leader>w", ":bd<CR>", { desc = "Delete buffer" })
mapkey("n", "<leader>m", ":Mason<CR>", { desc = "Mason" })
mapkey("n", "<leader>o", '<cmd>silent! execute "%bd|e#|bd#"<cr>', { desc = "Delete other buffers" })
mapkey("n", "<leader>\\", ":set invwrap<CR>", { desc = "Toggle wrap" })
mapkey("n", "<Tab>", ":bn<CR>", { desc = "Next buffer" })
mapkey("n", "<S-Tab>", ":bp<CR>", { desc = "Previous buffer" })
mapkey({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
mapkey("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart find files" })
mapkey("n", "<leader>f", function() Snacks.picker.files() end, { desc = "Find files" })
mapkey("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
mapkey("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Buffers" })
mapkey("n", "<leader>F", function() Snacks.picker.recent() end, { desc = "Recent files" })
mapkey("n", "<leader>?", function() Snacks.picker.help() end, { desc = "Help pages" })
mapkey("n", "<leader>e", function() Snacks.explorer() end, { desc = "File explorer" })
mapkey("n", "<leader>g", function() Snacks.lazygit() end, { desc = "Lazygit" })
mapkey("n", "<leader>l", ":checkhealth lsp<CR>", { desc = "LSP health" })
mapkey("n", "<leader>L", ":lsp restart<CR>", { desc = "LSP restart" })
mapkey("n", "<leader>h", function() Snacks.lazygit.log_file() end, { desc = "Lazygit file history" })
mapkey("n", "<leader>d", function() Snacks.picker.git_diff() end, { desc = "Git diff" })
mapkey("n", "<leader>k", function() Snacks.picker.keymaps() end, { desc = "View keymaps" })
mapkey("n", "<leader>s", function() Snacks.picker.lsp_symbols() end, { desc = "File LSP symbols" })
mapkey("n", "<leader>S", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace LSP symbols" })
mapkey("n", "<leader>t", function() Snacks.picker.colorschemes() end, { desc = "Workspace LSP symbols" })
mapkey("n", "<leader>x", function() sops.edit() end, { desc = "Edit sops file" })
mapkey("n", "<leader>.", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end,
	{ desc = "Workspace LSP symbols" })
mapkey("n", "<leader>!", function() Snacks.picker.notifications() end, { desc = "Notifications" })
mapkey("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
mapkey("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
mapkey("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
mapkey("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
mapkey("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
mapkey('n', '<leader>r', vim.lsp.buf.rename, { desc = 'LSP rename symbol' })
mapkey('n', 'f', "za", { desc = 'Toggle fold' })
mapkey('n', 'F', "zR", { desc = 'Open all folds' })
mapkey({ "n", "v" }, "<leader>n", function() mc.matchAddCursor(1) end)
mapkey({ "n", "v" }, "<leader>N", function() mc.matchSkipCursor(1) end)
mapkey({ "n", "v" }, "<leader>p", function() mc.matchAddCursor(-1) end)
mapkey({ "n", "v" }, "<leader>P", function() mc.matchSkipCursor(-1) end)
mapkey("n", "<c-leftmouse>", mc.handleMouse)
mapkey({ "n", "x" }, "<leader>c", mc.toggleCursor)
mapkey({ "n", "x" }, "<leader>C", function()
	if not mc.cursorsEnabled() then
		mc.enableCursors()
	else
		mc.clearCursors()
	end
end)

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
	callback = function(args)
		local clients = vim.lsp.get_clients({
			bufnr = args.buf,
			method = "textDocument/formatting",
		})
		if #clients > 0 then
			vim.lsp.buf.format({ bufnr = args.buf, async = false })
		end
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

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		-- Ensure the LSP client supports document highlighting
		if client and client.server_capabilities.documentHighlightProvider then
			local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })

			-- Highlight references when the cursor rests on a word
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = args.buf,
				group = group,
				callback = vim.lsp.buf.document_highlight,
			})

			-- Clear highlights immediately when the cursor moves
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = args.buf,
				group = group,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})
vim.opt.updatetime = 300

-- Trigger path completion on "/" character
vim.keymap.set('i', '/', function()
	vim.api.nvim_feedkeys('/', 'n', false)
	vim.schedule(function()
		-- Trigger completion menu if desired
		vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-f>', true, true, true), 'n')
	end)
end, { expr = true })
