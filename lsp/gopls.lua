return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", },
	root_markers = { "go.mod" },
	settings = {
		gopls = {
			semanticTokens = true,
			analyses = {
				unusedparams = true,  -- Warn about unused function parameters
				shadow = true,        -- Warn about variable shadowing
			},
			staticcheck = true,     -- Enables staticcheck.io analysis
			gofumpt = true,         -- Strict code formatting
			completeUnimported = true, -- Auto-complete packages not yet in imports
		},
	}
}
