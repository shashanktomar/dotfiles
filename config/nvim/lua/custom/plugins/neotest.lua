local ok, nt = pcall(require, 'neotest')

if not ok then return end

local neotest_ns = vim.api.nvim_create_namespace('neotest')
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      return message
    end,
  },
}, neotest_ns)

nt.setup({
  adapters = {
    require('neotest-go'),
    require('neotest-jest')({
      jestCommand = 'yarn jest',
    }),
  },
})
