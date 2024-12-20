vim.g.mapleader = ","

-- Folding:
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "0"

vim.opt.autowrite = true
vim.opt.autoread = true

vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.hidden = true

vim.opt.showcmd = true
vim.opt.cmdheight = 2

vim.opt.ruler = true

vim.opt.clipboard = "unnamed"

vim.opt.scrolloff = 20
vim.opt.sidescrolloff = 20
vim.opt.sidescroll = 1

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.number = true
vim.opt.numberwidth = 6
vim.opt.signcolumn = 'yes'

vim.opt.previewheight = 30

vim.opt.cursorline = true

vim.opt.backspace = "indent,eol,start"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smarttab = true

vim.opt.laststatus = 2
vim.opt.statusline = "%n %f %h%1*%m%r%w%0* [%{strlen(&ft)?&ft:'none'},%{&encoding},%{&fileformat}]%=0x%-8B %c,%l %o %P"

vim.opt.listchars = "tab:▸ ,eol:¬,trail:·"

vim.opt.cindent = true
vim.opt.smartindent = true

vim.o.cindent = true
vim.o.smartindent = true

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.phtml"},
  callback = function()
    vim.opt.filetype = "phtml"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {"phtml", "php", "html"},
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {"php", "phtml", "js", "odin"},
  callback = function()
    vim.opt.commentstring = "// %s"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {"sql"},
  callback = function()
    vim.opt.commentstring = "-- %s"
  end,
})

-- vim.cmd [[autocmd FileType javascript setlocal ts=4 sts=4 sw=4]]

local aug = vim.api.nvim_create_augroup("buf_large", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    if ok and stats and (stats.size > 1000000) then
      vim.b.large_buf = true
      vim.cmd("syntax off")
      vim.cmd("IBLDisable") -- disable indent-blankline.nvim
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.spell = false

      vim.cmd("filetype off")
      vim.cmd("set noundofile")
      vim.cmd("set noswapfile")
      vim.cmd("set noloadplugins")
    else
      vim.b.large_buf = false
    end
  end,
  group = aug,
  pattern = "*",
})

vim.diagnostic.config({virtual_text = false})
