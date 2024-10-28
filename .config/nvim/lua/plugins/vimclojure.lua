return {
  {
    'vim-scripts/VimClojure',
    init = function()
      vim.g.vimclojure_HighlightBuiltins = 1
      vim.g.vimclojure_ParenRainbow = 1
      vim.g.vimclojure_DynamicHighlighting = 1
      vim.g.vimclojure_FuzzyIndent = 1
    end
  }
}

