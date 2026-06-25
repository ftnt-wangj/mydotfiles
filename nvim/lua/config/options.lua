vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

local function set_reference_highlights()
  local groups = {
    "LspReferenceText",
    "LspReferenceRead",
    "LspReferenceWrite",
    "FixedWordHighlight",
  }

  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "#51412a", bold = true })
  end
end

set_reference_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_reference_highlights,
})
