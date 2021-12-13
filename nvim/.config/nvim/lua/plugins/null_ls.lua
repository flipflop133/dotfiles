local null_ls = require "null-ls"

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier.with {
			extra_args = { "--tab-width", "4" },
		},
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.diagnostics.write_good,
		null_ls.builtins.code_actions.gitsigns,
		-- Bash
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.shfmt,
		-- Python
		null_ls.builtins.formatting.yapf,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.diagnostics.flake8,
		null_ls.builtins.diagnostics.pylama,
	},
})
