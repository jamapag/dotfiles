-- Past without rewriting copied text
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without rewriting copied text", noremap = true })

-- Highlight last inserted text
vim.keymap.set("n", "gV", "`[v`]", { desc = "Highlight last inserted text", noremap = true })

-- Space toggle folds
vim.keymap.set("n", "<Space>", "za", { desc = "Toggle fold", noremap = true })
vim.keymap.set("v", "<Space>", "zf", { desc = "Toggle fold", noremap = true })

vim.keymap.set("n", "<leader>l", ":set list!<CR>", { desc = "Toggle showing tabs, spaces, trailing spaces" })

vim.keymap.set("n", "<leader>ce", ":e! ~/.config/nvim/init.lua<CR>", { desc = "Edit init.lua" })
vim.keymap.set("n", "<leader>cp", ":e! ~/.config/nvim/lua/plugins/general.lua<CR>", { desc = "Edit plugins/general.lua" })

-- Window jumping: Replaced with vim-tmux-navigator mappings.
-- vim.keymap.set("n", "<C-j>", "<C-W>j")
-- vim.keymap.set("n", "<C-k>", "<C-W>k")
-- vim.keymap.set("n", "<C-h>", "<C-W>h")
-- vim.keymap.set("n", "<C-l>", "<C-W>l")

-- Make Y to consistent with C and D
vim.keymap.set("n", "Y", "y$", { noremap = true })

-- Move vertically by visual line
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })

-- Esc in insert mode
vim.keymap.set("i", "jk", "<ESC>", { noremap = true })
vim.keymap.set("i", "jj", "<ESC>", { noremap = true })
vim.keymap.set("i", "kk", "<ESC>", { noremap = true })

-- Move visual selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })

-- Stay in middle of screen
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })

vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

-- Super paste
vim.keymap.set("i", "<C-v>", "<ESC>:set paste<CR>mui<C-R>+<ESC>mv'uV'v=:set nopaste<CR>", { noremap = true })


vim.keymap.set("n", "<leader>id", ':lua require("custom.phpdoc").insert_php_doc()<CR>', { desc = "Insert php doc string", noremap = true })

vim.keymap.set("n", "<leader>t2", ':set shiftwidth=2<CR>', { noremap = true })
vim.keymap.set("n", "<leader>t4", ':set shiftwidth=4<CR>', { noremap = true })
