-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/francois/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/francois/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/francois/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/francois/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/francois/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    config = { "\27LJ\1\2H\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\tload luasnip/loaders/from_vscode\frequire\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/LuaSnip"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["compe-tabnine"] = {
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/compe-tabnine"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  ["github-nvim-theme"] = {
    config = { "\27LJ\1\2y\0\0\2\0\b\0\v4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\4\0%\1\5\0>\0\2\0027\0\6\0003\1\a\0>\0\2\1G\0\1\0\1\0\1\15themeStyle\nlight\nsetup\17github-theme\frequire\nlight\15background\6o\bvim\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/github-nvim-theme"
  },
  ["lsp_signature.nvim"] = {
    config = { "\27LJ\1\2S\0\0\2\0\4\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\1G\0\1\0\1\0\1\16hint_enable\1\14on_attach\18lsp_signature\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/francois/.local/share/nvim/site/pack/packer/opt/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\1\0024\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\tinit\flspkind\frequire\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\1\2\\\0\0\3\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\1>\0\2\1G\0\1\0\foptions\1\0\0\1\0\1\ntheme\vgithub\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  neoformat = {
    config = { "\27LJ\1\2)\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\14neoformat\frequire\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/neoformat"
  },
  ["nnn.vim"] = {
    commands = { "Np", "NnnPicker" },
    loaded = false,
    needs_bufread = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/opt/nnn.vim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\1\2ž\1\0\0\2\0\6\0\r4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\0014\0\0\0%\1\4\0>\0\2\0027\0\2\0003\1\5\0>\0\2\1G\0\1\0\1\0\2\17map_complete\2\vmap_cr\2$nvim-autopairs.completion.compe\1\0\1\rcheck_ts\2\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\1\0027\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\1\2*\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\15completion\frequire\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\1\2#\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\blsp\frequire\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20treesitter-nvim\frequire\0" },
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-ts-autotag"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/francois/.local/share/nvim/site/pack/packer/opt/nvim-ts-autotag"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/home/francois/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20treesitter-nvim\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\1\0027\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: github-nvim-theme
time([[Config for github-nvim-theme]], true)
try_loadstring("\27LJ\1\2y\0\0\2\0\b\0\v4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\4\0%\1\5\0>\0\2\0027\0\6\0003\1\a\0>\0\2\1G\0\1\0\1\0\1\15themeStyle\nlight\nsetup\17github-theme\frequire\nlight\15background\6o\bvim\0", "config", "github-nvim-theme")
time([[Config for github-nvim-theme]], false)
-- Config for: nvim-compe
time([[Config for nvim-compe]], true)
try_loadstring("\27LJ\1\2*\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\15completion\frequire\0", "config", "nvim-compe")
time([[Config for nvim-compe]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\1\0024\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: neoformat
time([[Config for neoformat]], true)
try_loadstring("\27LJ\1\2)\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\14neoformat\frequire\0", "config", "neoformat")
time([[Config for neoformat]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\1\2\\\0\0\3\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\1>\0\2\1G\0\1\0\foptions\1\0\0\1\0\1\ntheme\vgithub\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\1\2H\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\tload luasnip/loaders/from_vscode\frequire\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
try_loadstring("\27LJ\1\2ž\1\0\0\2\0\6\0\r4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\0014\0\0\0%\1\4\0>\0\2\0027\0\2\0003\1\5\0>\0\2\1G\0\1\0\1\0\2\17map_complete\2\vmap_cr\2$nvim-autopairs.completion.compe\1\0\1\rcheck_ts\2\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-autopairs")
time([[Config for nvim-autopairs]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\1\2#\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\blsp\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file NnnPicker lua require("packer.load")({'nnn.vim'}, { cmd = "NnnPicker", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
pcall(vim.cmd, [[command! -nargs=* -range -bang -complete=file Np lua require("packer.load")({'nnn.vim'}, { cmd = "Np", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'lsp_signature.nvim'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
