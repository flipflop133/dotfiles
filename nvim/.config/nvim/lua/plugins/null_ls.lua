local null_ls = require "null-ls"

require("lspconfig")["null-ls"].setup {}
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier.with {
			extra_args = { "--tab-width", "4" },
		},
		null_ls.builtins.diagnostics.shellcheck,
	},
	on_attach = on_attach,
})
