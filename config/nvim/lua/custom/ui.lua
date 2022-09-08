local M = {}

M.hl_override = {
  -- treesitter
  TSDefinition = { link = 'Visual' },
  TSDefinitionUsage = { link = 'Visual' },
}

M.hl_add = {
  -- lspsaga
  LspSagaCodeActionTitle = { link = 'Title' },
  LspSagaFinderSelection = { link = 'Visual' },
  LspSagaLspFinderBorder = { fg = 'grey' },
  LspSagaDefPreviewBorder = { fg = 'grey' },
  FinderSpinnerBorder = { fg = 'grey' },
  LspSagaAutoPreview = { fg = 'grey' },
  LspSagaCodeActionBorder = { fg = 'grey' },
  FinderVirtText = { fg = 'line' },
  FinderParam = { fg = 'black', bg = 'green' },
  LspSagaCodeActionContent = { fg = 'white' },
  LspSagaDiagnosticSource = { fg = 'white' },
}

return M
