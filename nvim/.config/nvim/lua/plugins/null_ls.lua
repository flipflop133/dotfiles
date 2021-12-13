local null_ls = require "null-ls"
null_ls.config {
	sources = {
		null_ls.builtins.formatting.prettier.with {
			extra_args = { "--tab-width", "4" },
		},
		null_ls.builtins.diagnostics.shellcheck,
	},
}

require("lspconfig")["null-ls"].setup {}
