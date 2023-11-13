local wiki = {}

local function Open_Wiki()
  local path = wiki.path
  if vim.fn.filereadable(vim.fn.expand(path .. 'index.md')) == 0 then
    vim.cmd("silent !mkdir -p " .. path)
    vim.cmd("silent !touch " .. path .. 'index.md')
  end
  vim.cmd("e " .. path .. "index.md")
end

local function Create_Open()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if node then
    if node:type() == "link_text" or node:type() == "link_destination" then
      local line    = vim.api.nvim_get_current_line()
      local pattern = "[^.]+([^)]+)"
      local path    = string.match(line, pattern)
      vim.cmd(":tabe " .. path)
    elseif node:type() == 'inline' then
      local s_l, s_r = vim.fn.getpos('v')[2], vim.fn.getpos('v')[3]
      local e_l, e_r = vim.fn.getpos('.')[2], vim.fn.getpos('.')[3]
      local file_name = vim.fn.getline(s_l, e_l)
      file_name[1] = string.sub(file_name[1], s_r)
      file_name[#file_name] = string.sub(file_name[#file_name], 1, e_r)
      local file_text = table.concat(file_name, "")
      local file_link = string.gsub(file_text, " ", "_") .. ".md"
      vim.api.nvim_input('c' .. '[' .. file_text .. '](./' .. file_link .. ')<esc>:tabe ' .. file_link .. '<CR>')
    end
  else
    return
  end
end

local function setup(opt)
  wiki = vim.tbl_extend('force', {
    path = '~/wiki/',
    wiki_open = '<leader>ww',
    wiki_file = '<cr>',
  }, opt or {})
  vim.keymap.set('n', wiki.wiki_open, Open_Wiki, {})
  vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
    pattern = "*.md",
    callback = function()
      vim.keymap.set({ 'n', 'v' }, wiki.wiki_file, Create_Open, {})
    end
  })
end

return {
  setup = setup
}
