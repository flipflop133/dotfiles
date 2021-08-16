vim.cmd [[packadd nvim-ts-autotag]]
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
	highlight = {
		enable = true,
		disable = { "html"}
	},
	autotag = {
		enable = true,
	},
	autopairs = {
		enable = true
	}
}
