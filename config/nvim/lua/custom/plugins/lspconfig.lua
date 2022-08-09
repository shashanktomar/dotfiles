local present, lsp = pcall(require, "lspconfig")

if not present then
 return
end

-- custom.plugins.lspconfig
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local servers = {"bashls"}

for _, plugin in ipairs(servers) do
  lsp[plugin].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- This is not working :(. 
-- Check https://github.com/dagger/cuelsp/blob/main/docs/vim.md 
-- and https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dagger
-- dagger needs special setup for now
lsp.dagger.setup{
  cmd = {"dagger", "cuelsp"},
  filetypes = { "cue" },
  on_attach = on_attach,
  capabilities = capabilities
}
