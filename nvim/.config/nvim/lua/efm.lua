local M = {}
local htmlhint = {
  lintCommand = 'htmlhint -f compact',
  lintStdin = true,
  lintFormats = {
    '%f: line %l, col %c, %trror - %m', '%f: line %l, col %c, %tarning - %m'
  }
}

M.languages = {
  html = {htmlhint},
}

M.filetypes = {}
for k, _ in pairs(M.languages) do
  M.filetypes[#M.filetypes + 1] = k
end

return M
