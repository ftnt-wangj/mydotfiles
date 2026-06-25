return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = true,
          },
        },
        win = {
          list = {
            keys = {
              ["<C-l>"] = "focus_preview",
            },
          },
          preview = {
            keys = {
              ["<C-h>"] = "focus_list",
            },
          },
        },
      },
    },
  },
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "auto" } } },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>f", group = "file/find" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
      },
    },
  },
}
