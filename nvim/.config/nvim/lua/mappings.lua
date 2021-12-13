local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-- Telescope
map("n", "<Space><Space>", ":Telescope find_files<CR>", opt)
map("n", "<Space>bb", ":Telescope buffers<CR>", opt)
map("n", "<Space>ff", ":Telescope file_browser<CR>", opt)
map("n", "<Space>ss", ":Telescope grep_string<CR>", opt)
map("n", "<Space>gg", ":Telescope live_grep<CR>", opt)
map("n", "<Space>rr", ":Telescope lsp_references<CR>", opt)
map("n", "<Space>zz", ":Telescope diagnostics bufnr=0<CR>", opt)
map("n", "<Space>ca", ":Telescope lsp_code_actions<CR>", opt)
