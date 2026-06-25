local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>e", "<cmd>LazyVimFiles<cr>", { desc = "Find files" })
map("n", "<leader>sw", "<cmd>RgCursor<cr>", { desc = "Grep word under cursor" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

local fixed_word_match_id

local function clear_fixed_word_highlight()
  if fixed_word_match_id then
    pcall(vim.fn.matchdelete, fixed_word_match_id)
    fixed_word_match_id = nil
  end
end

local function highlight_fixed_word()
  local word = vim.fn.expand("<cword>")
  if word == nil or word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end

  clear_fixed_word_highlight()
  local pattern = [[\V\<]] .. vim.fn.escape(word, [[\]]) .. [[\>]]
  fixed_word_match_id = vim.fn.matchadd("FixedWordHighlight", pattern, 20)
  vim.notify("Highlight: " .. word, vim.log.levels.INFO)
end

map("n", "<Space>hh", highlight_fixed_word, { desc = "Highlight word under cursor" })
map("n", "<Space>hc", clear_fixed_word_highlight, { desc = "Clear word highlight" })

vim.api.nvim_create_user_command("RgCursor", function()
  local word = vim.fn.expand("<cword>")
  if word == nil or word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end
  Snacks.picker.grep({ search = word })
end, { desc = "Ripgrep word under cursor" })

vim.api.nvim_create_user_command("RgWORD", function()
  local word = vim.fn.expand("<cWORD>")
  if word == nil or word == "" then
    vim.notify("No WORD under cursor", vim.log.levels.WARN)
    return
  end
  Snacks.picker.grep({ search = word })
end, { desc = "Ripgrep WORD under cursor" })

vim.api.nvim_create_user_command("FtsCopyTester", function()
  local cmd = {
    "/bin/busybox",
    "ftpput",
    "10.59.87.171",
    "/wang/Tester",
    "daemon/Tester/Tester",
  }
  local cmd_str = table.concat(cmd, " ")
  vim.notify("Running: " .. cmd_str, vim.log.levels.INFO)
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify("Completed: " .. cmd_str, vim.log.levels.INFO)
        else
          vim.notify("Failed (exit " .. code .. "): " .. cmd_str, vim.log.levels.ERROR)
        end
        end)
      end,
  })
end, { desc = "Copy Tester via busybox ftpput" })
