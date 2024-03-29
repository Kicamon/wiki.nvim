local wiki = {}

local function Open_Wiki()
  local path = wiki.path
  if vim.fn.filereadable(vim.fn.expand(path .. 'index.md')) == 0 then
    vim.cmd("silent !mkdir -p " .. path)
    vim.cmd("silent !touch " .. path .. 'index.md')
  end
  vim.cmd("edit " .. path .. "index.md")
end

local function Create_Open()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if node then
    if node:type() == "link_text" or node:type() == "link_destination" then
      local line = vim.api.nvim_get_current_line()
      local pattern = '[^/]+(.-)%)'
      local path = string.match(line, pattern)
      path = vim.fn.expand('%:p:~:h') .. path
      vim.cmd(":edit " .. path)
    elseif node:type() == 'inline' then
      local ln, tl, tr = vim.fn.line('.'), vim.fn.getpos('v')[3], vim.fn.getpos('.')[3]
      local line = vim.fn.getline(ln)
      if line:sub(tr):find('[\227-\233\128-\191]') == 1 then
        tr = tr + 2
      end
      local file_name = string.sub(line, tl, tr)
      local fine_link = './' .. string.gsub(file_name, " ", "_") .. '.md'
      local line_front = tl == 1 and '' or string.sub(line, 1, tl - 1)
      local line_end = tr == #line and '' or string.sub(line, tr + 1)
      local line_mid = '[' .. file_name .. '](' .. fine_link .. ')'
      vim.fn.setline(ln, line_front .. line_mid .. line_end)
      vim.api.nvim_input('<ESC>')
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
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.md",
    callback = function()
      vim.keymap.set({ 'n', 'v' }, wiki.wiki_file, Create_Open, { buffer = true })
    end
  })
end

return {
  setup = setup
}
