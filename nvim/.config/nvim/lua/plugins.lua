return require('packer').startup(
function()
	-- Packer can manage itself
	use "wbthomason/packer.nvim"

	-- Theme
	use {
		'projekt0n/github-nvim-theme',
		config = function()
			require('github-theme').setup({
				themeStyle = "dark",
			})
		end
	}

	-- Status line
	use {
		'hoob3rt/lualine.nvim',
		config = function()
			require'lualine'.setup{options={theme = 'github'}}
		end
	}

	-- Treesitter
	use {
		'nvim-treesitter/nvim-treesitter',
		config = function()
			require("treesitter-nvim")
		end
	}

	-- LSP
	use {
		"neovim/nvim-lspconfig",
		config = function()
			require "lsp"
		end
	}

	use {
		"onsails/lspkind-nvim",
		config = function()
			require("lspkind").init()
		end
	}

	use 'kabouzeid/nvim-lspinstall'


	-- Formatting
	use {
		"sbdchd/neoformat",
		config = function()
			require "neoformat"
		end,
	}

	-- Completion
	use {
		'hrsh7th/nvim-compe',
		config = function()
			require('completion')
		end
	}

	use {'hrsh7th/vim-vsnip', requires = 'hrsh7th/nvim-compe'}
	use {'hrsh7th/vim-vsnip-integ'}

	use {'tzachar/compe-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-compe'}

	-- Function signature
	use {
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		config = function()
			require"lsp_signature".on_attach({
				hint_enable = false
			})
		end
	}

	-- Snippets
	use {
		"L3MON4D3/LuaSnip",
		requires = {
			{
				"rafamadriz/friendly-snippets"
			}
		},
		config = function()
			require"luasnip/loaders/from_vscode".load()
		end
	}

	-- Autopairs
	use {
		"windwp/nvim-autopairs",
		config = function()
			require"nvim-autopairs".setup({
				check_ts = true,
			})
			require"nvim-autopairs.completion.compe".setup({
				map_cr = true,
				map_complete = true
			})
		end
	}

	-- Auto close tags
	use {
		"windwp/nvim-ts-autotag",
		opt = true
	}

	-- Colorizer
	use{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require'colorizer'.setup()
		end
	}

	-- Icons
	use "kyazdani42/nvim-web-devicons"

	-- File manager
	use {
		"mcchrish/nnn.vim",
		cmd = {"Np", "NnnPicker"}
	}
	
	-- Tabs management
	use "romgrk/barbar.nvim"
end)
