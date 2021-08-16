local on_attach = function(client, bufnr)
	-- Format on save
	vim.cmd([[autocmd BufWritePre * Neoformat]])
	-- Mappings.
	local opts = { noremap=true, silent=true }

end

-- lsp-install
local function setup_servers()
	require'lspinstall'.setup()
	-- get all installed servers
	local servers = require'lspinstall'.installed_servers()
	for _, server in pairs(servers) do
		require'lspconfig'[server].setup{
			on_attach = on_attach
		}
	end
end
setup_servers()


local servers = {
	"html",
	"cssls"
}

for _, lsp in ipairs(servers) do
	require'lspconfig'[lsp].setup{
		on_attach = custom_attach,
	}
end

local efm = require "efm"
require'lspconfig'.efm.setup{
	init_options = {documentFormatting = true},
	filetypes = efm.filetypes,
	settings = {
		rootMarkers = {vim.loop.cwd()},
		languages = efm.languages,
	},
}

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
	setup_servers() -- reload installed servers
	vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- Replace the default lsp diagnostic letters with prettier symbols
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})
