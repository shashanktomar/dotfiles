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

  -- notify
  NotifyERRORBorder = { fg = 'red' },
  NotifyERRORIcon = { fg = 'red' },
  NotifyERRORTitle = { fg = 'red' },
  NotifyWARNBorder = { fg = 'orange' },
  NotifyWARNIcon = { fg = 'orange' },
  NotifyWARNTitle = { fg = 'orange' },
  NotifyINFOBorder = { fg = 'green' },
  NotifyINFOIcon = { fg = 'green' },
  NotifyINFOTitle = { fg = 'green' },
  NotifyDEBUGBorder = { fg = 'grey' },
  NotifyDEBUGIcon = { fg = 'grey' },
  NotifyDEBUGTitle = { fg = 'grey' },
  NotifyTRACEBorder = { fg = 'purple' },
  NotifyTRACEIcon = { fg = 'purple' },
  NotifyTRACETitle = { fg = 'purple' },
}

return M
