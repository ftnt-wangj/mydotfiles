return {
  {
    "LazyVim/LazyVim",
    init = function()
      vim.filetype.add({
        filename = {
          Earthfile = "Earthfile",
          Tiltfile = "starlark",
        },
        extension = {
          avsc = "json",
          avdl = "avro-idl",
          tf = "terraform",
          tfvars = "terraform",
          hcl = "hcl",
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts = opts or {}

      local services_root = vim.fn.expand("~/code/cnapp/lacework/services")

      opts.root_dir = function(path)
        if path and vim.startswith(vim.fn.fnamemodify(path, ":p"), services_root) then
          return services_root
        end
        return vim.fs.root(path, {
          "BUILD.bazel",
          "BUILD",
          "pom.xml",
          "build.gradle",
          "build.gradle.kts",
          "settings.gradle",
          "settings.gradle.kts",
          ".git",
        })
      end

      -- The services repo root has bazel-bin/bazel-out/bazel-services/bazel-testlogs
      -- symlinks into the Bazel execroot, which mirrors the whole workspace plus
      -- external deps. Without excluding them, jdtls will recurse into a near-infinite
      -- duplicate tree and never finish indexing.
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          import = {
            exclusions = {
              "**/bazel-bin/**",
              "**/bazel-out/**",
              "**/bazel-services/**",
              "**/bazel-testlogs/**",
              "**/.bazelbsp/**",
            },
          },
        },
      })

      local java21 = vim.fn.expand("~/.local/share/jdks/jdk-21.0.11+10/bin/java")
      if vim.fn.filereadable(java21) == 1 then
        opts.cmd = opts.cmd or { vim.fn.exepath("jdtls") }

        local has_java_executable = false
        for _, part in ipairs(opts.cmd) do
          if vim.startswith(part, "--java-executable") then
            has_java_executable = true
            break
          end
        end

        if not has_java_executable then
          table.insert(opts.cmd, "--java-executable")
          table.insert(opts.cmd, java21)
        end
      end

      return opts
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "basedpyright",
        "ruff",
        "rust-analyzer",
        "clangd",
        "jdtls",
        "java-debug-adapter",
        "java-test",
        "stylua",
        "shfmt",
        "prettier",
        "google-java-format",
        "terraform-ls",
        "tflint",
        "taplo",
        "typescript-language-server",
        "json-lsp",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = false,
      sync_install = false,
      ignore_install = { "vimdoc" },
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "go",
        "gomod",
        "gosum",
        "hcl",
        "java",
        "json",
        "lua",
        "markdown",
        "rust",
        "starlark",
        "terraform",
        "toml",
        "typescript",
        "yaml",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = vim.tbl_extend("force", opts.servers or {}, {
        basedpyright = {},
        ruff = {},
        rust_analyzer = {},
        clangd = {},
        lua_ls = {},
        bashls = {},
        terraformls = {},
        tflint = {},
        taplo = {},
        ts_ls = {},
        jsonls = {},
      })

      -- nvim-lspconfig's gopls setup calls `go` while detecting the module root.
      -- Enable it only in environments where the Go toolchain is actually present.
      if vim.fn.executable("go") == 1 then
        opts.servers.gopls = {}
      else
        opts.servers.gopls = { enabled = false }
      end

      return opts
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        go = { "gofmt" },
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        sh = { "shfmt" },
        java = { "google-java-format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        terraform = { "terraform_fmt" },
        hcl = { "terragrunt_hclfmt", "terraform_fmt" },
        toml = { "taplo" },
      },
    },
  },
  {
    "earthly/earthly.vim",
    ft = { "Earthfile" },
  },
}
