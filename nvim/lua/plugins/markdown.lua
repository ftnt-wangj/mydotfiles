return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>", ft = "markdown", desc = "Markdown preview" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", ft = "markdown", desc = "Stop Markdown preview" },
      { "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Toggle Markdown preview" },
    },
  },
}
