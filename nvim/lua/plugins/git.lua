return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.current_line_blame = true
      opts.current_line_blame_opts = {
        delay = 300,
      }

      opts.on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>ghs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selection")
        map("v", "<leader>ghr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selection")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
      end

      return opts
    end,
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.terminal = opts.terminal or {}
      return opts
    end,
    keys = {
      {
        "<leader>gt",
        function()
          Snacks.terminal("tig", { cwd = LazyVim.root.git() })
        end,
        desc = "Tig status",
      },
      {
        "<leader>gT",
        function()
          local file = vim.fn.expand("%:p")
          if file == "" then
            Snacks.notify.warn("No file in current buffer")
            return
          end
          Snacks.terminal({ "tig", vim.fn.fnamemodify(file, ":.") }, { cwd = LazyVim.root.git() })
        end,
        desc = "Tig file history",
      },
      {
        "<leader>ghc",
        function()
          local commit = vim.fn.expand("<cword>")
          if not commit:match("^[0-9a-fA-F]+$") then
            Snacks.notify.warn("Cursor is not on a commit hash")
            return
          end
          Snacks.terminal({ "tig", commit }, { cwd = LazyVim.root.git() })
        end,
        desc = "Tig commit",
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 0.95
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_use_plenary = 0
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    end,
    cmd = {
      "LazyGit",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gc", "<cmd>LazyGitFilter<cr>", desc = "LazyGit commits" },
      { "<leader>gC", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit file commits" },
      { "<leader>gF", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit current file" },
      { "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "LazyGit filter" },
    },
  },
}
