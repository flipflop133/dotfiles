local treesitter = require "nvim-treesitter.configs"

-- Treesitter setup
treesitter.setup {
	ensure_installed = {
		"comment",
		"bash",
		"c",
		"python",
		"lua",
		"javascript",
		"html",
		"css",
	},

	highlight = {
		enable = true,
	},
}
