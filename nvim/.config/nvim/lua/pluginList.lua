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
		requires = {'kyazdani42/nvim-web-devicons'},
		config = function()
			require("lualine").setup {options = {theme = "github"}}
		end
	}

	-- Theme
	use {
		"projekt0n/github-nvim-theme",
		requires = {{"hoob3rt/lualine.nvim"}},
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
		config = function()
			require "plugins.cmp"
		end,
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-vsnip" },
			{ "tzachar/cmp-tabnine",run='./install.sh' },
		},
	}

	-- Language server configs
	use {
		"neovim/nvim-lspconfig",
	}

	-- Null language server
		use {
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require "plugins.null_ls"
			end,
		}

	-- Language server installer
	use {
		"williamboman/nvim-lsp-installer"
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
		run = ":TSUpdate",
	}

	-- Snippets
	use {
		"hrsh7th/vim-vsnip",
		requires = {
			"rafamadriz/friendly-snippets",
		},
	}

	-- Auto close pairs
	use {
		"windwp/nvim-autopairs",
	}

	-- Icons
	use { "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" }
end)
