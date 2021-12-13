local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
return require('packer').startup(function()
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Status line
	use {
		'nvim-lualine/lualine.nvim',
		requires = {'kyazdani42/nvim-web-devicons', opt = true},
		config = function()
			require("lualine").setup {options = {theme = "github"}}
		end
	}

	-- Theme
	use {
		"projekt0n/github-nvim-theme",
		requires = {{"hoob3rt/lualine.nvim", opt = true}},
		config = function()
			vim.o.background = "dark"
			require("github-theme").setup({theme_style = "dark"})
		end
	}

	-- Telescope
	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	-- Completion
	use {
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			require "plugins.cmp"
		end,
		requires = {
			{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
			{ "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
			{ "hrsh7th/cmp-vsnip", after = "nvim-cmp" },
			{ "tzachar/cmp-tabnine",run='./install.sh', after = "nvim-cmp" },
		},
	}

	-- Language server configs
	use {
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
	}

	-- Language server installer
	use {
		"williamboman/nvim-lsp-installer"
	}

	-- Null language server
	use {
		"jose-elias-alvarez/null-ls.nvim",
		after = "nvim-lspconfig",
		config = function()
			require "plugins.null_ls"
		end,
	}

	-- Vscode-like pictograms
	use {
		"onsails/lspkind-nvim",
		config = function()
			require("lspkind").init()
		end,
	}

	-- Better syntax highlighting
	use {
		"nvim-treesitter/nvim-treesitter",
		event = "BufRead",
		run = ":TSUpdate",
	}

	-- Snippets
	use {
		"hrsh7th/vim-vsnip",
		event = "InsertCharPre",
		requires = {
			"rafamadriz/friendly-snippets",
		},
	}

	-- Auto close pairs
	use {
		"windwp/nvim-autopairs",
		after = "nvim-cmp",
	}

	-- Icons
	use { "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" }
end)
