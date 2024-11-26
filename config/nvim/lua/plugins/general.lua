return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
      require("tokyonight").setup({
        on_highlights = function(hl, c)
          hl.MiniCursorword = { underline = true }
          hl.MiniCursorwordCurrent = { underline = true }
        end,
      })

      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function ()
      require('mini.extra').setup()
      require('mini.bufremove').setup({})
      require('mini.pairs').setup({})
      require("mini.cursorword").setup({})
      require("mini.surround").setup({})
      require("mini.ai").setup({})
      require("mini.statusline").setup({})
      require("mini.trailspace").setup({})
      require("mini.splitjoin").setup({})
      require("mini.files").setup({
        windows = {
          preview = true,
          width_preview = 60,
        },
      })
      require("mini.pick").setup({})
      require("mini.indentscope").setup({
        symbol = '│',
      })
      -- require("mini.clue").setup({
      --   triggers = {
      --     -- Leader triggers
      --     { mode = 'n', keys = '<Leader>' },
      --
      --     { mode = 'n', keys = ']' },
      --     { mode = 'n', keys = '[' },
      --
      --     -- Built-in completion
      --     { mode = 'i', keys = '<C-x>' },
      --
      --     -- `g` key
      --     { mode = 'n', keys = 'g' },
      --     { mode = 'x', keys = 'g' },
      --     { mode = 'x', keys = '<Leader>' },
      --   }
      -- })

      local files_find_in_dir = function(path)
        -- Works only if cursor is on the valid file system entry
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        MiniFiles.close()
        require('telescope.builtin').live_grep({search_dirs = {cur_directory}})
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          vim.keymap.set('n', 'gfg', files_find_in_dir, { buffer = args.data.buf_id })
        end,
      })

      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
          todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
          note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })

      vim.keymap.set("n", "<leader>bd", ":lua MiniBufremove.wipeout()<CR>", { desc = "Delete buffer" })

      vim.keymap.set("n", "<leader>pg", ":Pick grep_live<CR>", { desc = "Pick grep_live" })
      vim.keymap.set("n", "<leader>pG", ":Pick grep pattern='<cword>'<CR>", { desc = "Pick: grep current word", noremap = false })
      vim.keymap.set("n", "<leader>pf", ":Pick files<CR>", { desc = "Pick files" })
      vim.keymap.set("n", "<leader>pb", ":Pick buffers<CR>", { desc = "Pick: buffers", noremap = false })
      vim.keymap.set("n", "<leader>pd", ":Pick diagnostic scope='current'<CR>", { desc = "Pick: diagnostic", noremap = false })
      vim.keymap.set("n", "<leader>pr", ":Pick lsp scope='references'<CR>", { desc = "Pick: lsp references", noremap = false })

      vim.keymap.set("n", "<leader>nn", ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", { desc = "Open MiniFiles"})
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function ()
      require('telescope').setup({})

      -- Find files using Telescope command-line sugar.
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Telescope: find_files", noremap = false })
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Telescope: live_grep", noremap = false })
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Telescope: buffers", noremap = false })
      vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope: help_tags", noremap = false })
    end
  },
  { "christoomey/vim-tmux-navigator" },
  { 'christoomey/vim-tmux-runner' },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function ()
      local function on_attach(bufnr)
        local api = require('nvim-tree.api')
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set('n', 'gcd', function()
          local node = api.tree.get_node_under_cursor()
          local core = require "nvim-tree.core"
          if node.name == ".." then
            print(core.get_cwd())
            vim.api.nvim_command('cd ' .. core.get_cwd())
          else
            if node.fs_stat.type == "directory" then
              print(node.absolute_path)
              vim.api.nvim_command('cd ' .. node.absolute_path)
            end
          end
        end, opts('change dir'))

        vim.keymap.set('n', 'A', function()
          local view = require "nvim-tree.view"
          if view.View.width < 100 then
            view.resize('+300')
          else
            view.resize('-300')
          end
        end, opts('Toggle NvimTree Zoom'))

        vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
        vim.keymap.set('n', 'gs', api.node.run.system, opts('Run System'))
        vim.keymap.set('n', 'gfg', function()
          local node = api.tree.get_node_under_cursor()
          if not node then return end
          require('telescope.builtin').live_grep({search_dirs = {node.absolute_path}})
        end, opts('Telescope live_grep in folder'))

      end

      require("nvim-tree").setup({
        update_focused_file = {
          enable = true,
        },
        on_attach = on_attach,
        renderer = {
          group_empty = false,
        },
        filters = {
          dotfiles = false,
        },
        hijack_netrw = false,
      })

      vim.keymap.set("n", "<leader>ne", ":NvimTreeFindFileToggle<CR>")
    end,
  },
  -- Show marks
  { "kshenoy/vim-signature" },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ':TSUpdate',
    opts = {
      auto_install = true,
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        -- "comment", -- comments are slowing down TS bigtime, so disable for now
        "cpp",
        "css",
        "diff",
        "dart",
        "fish",
        "gitignore",
        "go",
        "graphql",
        "vimdoc",
        "html",
        "http",
        "java",
        "javascript",
        "jsdoc",
        "jsonc",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "meson",
        "ninja",
        "nix",
        "norg",
        "org",
        "php",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "sql",
        "svelte",
        "teal",
        "toml",
        "tsx",
        "typescript",
        "vhs",
        "vim",
        "vue",
        "wgsl",
        "yaml",
        -- "wgsl",
        "json",
        -- "markdown",
      },
      highlight = {
        enable = true,
        disable = function()
          return vim.b.large_buf
        end
      },
      indent = { enable = true },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        }
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = true, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
    },
    config = function (opts)
      require("nvim-treesitter.configs").setup(opts.opts)
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function ()
      require("ibl").setup {
        scope = {
          enabled = false,
        },
      }
    end
  },
  {
    -- "hrsh7th/nvim-cmp",
    "iguanacucumber/magazine.nvim",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
    },
    config = function ()
      local cmp = require("cmp")
      cmp.setup({
        completion = {
          keyword_length = 1,
          completeopt = 'menu,menuone,noinsert,noselect',
        },
        snippet = {
          expand = function (args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<C-e>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
          -- ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          {
            name = 'buffer',
            option = {
              get_bufnrs = function ()
                return vim.api.nvim_list_bufs()
              end
            },
          },
          { name = 'vsnip', keyword_pattern = [[\S\+]] },
          -- { name = 'vsnip' },
          { name = 'path' }
        })
      })

      local autocomplete_group = vim.api.nvim_create_augroup('vimrc_autocompletion', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          cmp.setup.buffer({
            sources = {
              { name = 'vim-dadbod-completion' },
              { name = 'buffer' },
              { name = 'vsnip' },
            },
          })
        end,
        group = autocomplete_group,
      })

      vim.api.nvim_set_keymap('i', '<Tab>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<Tab>"', { silent = true, expr = true })
      vim.api.nvim_set_keymap('s', '<Tab>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<Tab>"', { silent = true, expr = true })
      vim.api.nvim_set_keymap('i', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"', { silent = true, expr = true })
      vim.api.nvim_set_keymap('s', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"', { silent = true, expr = true })

      -- vim.api.nvim_create_autocmd(
      --   {"TextChangedI", "TextChangedP"},
      --   {
      --     callback = function()
      --       local line = vim.api.nvim_get_current_line()
      --       local cursor = vim.api.nvim_win_get_cursor(0)[2]
      --
      --       local current = string.sub(line, cursor, cursor + 1)
      --       if current == "." or current == "," or current == " " then
      --         require('cmp').close()
      --       end
      --
      --       local before_line = string.sub(line, 1, cursor + 1)
      --       local after_line = string.sub(line, cursor + 1, -1)
      --       if not string.match(before_line, '^%s+$') then
      --         if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
      --           require('cmp').complete()
      --         end
      --       end
      --     end,
      --     pattern = "*"
      --   })
    end
  },
  {
    "williamboman/mason.nvim",
    config = function ()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function ()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "phpactor",
          "cssls",
          "html",
          "ts_ls",
          "ols",
        },
      }

      -- local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lsp_attach = function(client, bufnr)
        -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local function opts(desc)
          return { desc = desc, noremap = true, silent = true }
        end


        -- See `:help vim.lsp.*` for documentation on any of the below functions
        --buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        --buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts("Lsp: Go to declaration"))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts("Lsp: Go to definition"))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts("Lsp: Buf hover"))
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts("Lsp: Go to implementation"))
        vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts("Lsp: Signature help"))
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts("Lsp: Add workspace folder"))
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts("Lsp: Remove workspace folder"))
        vim.keymap.set('n', '<leader>wl', function()
          vim.inspect(vim.lsp.buf.list_workspace_folders())
        end, opts("Lsp: List workspace folders"))
        vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, opts("[W]orkspace [S]ymbols"))
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts("Lsp: Type difinition"))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts("Lsp: buf rename"))
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts("Lsp: show references"))
        vim.keymap.set('n', '<leader>lca', vim.lsp.buf.code_action, opts("Lsp: code actions"))
        vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, opts("Lsp: telescope document symbols"))
        vim.keymap.set('n', '<leader>df', vim.diagnostic.goto_next, opts("Lsp: diagnostic goto next"))
        vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, opts("Lsp: diagnostic goto prev"))
        vim.keymap.set('n', '<leader>dl', "<cmd>Telescope diagnostics<cr>", opts("Lsp: telescope diagnostics"))

        vim.api.nvim_create_user_command("Format", vim.lsp.buf.format, {})
      end

      local lspconfig = require('lspconfig')
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
          })
        end,
        ["lua_ls"] = function ()
          lspconfig["lua_ls"].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                }
              }
            }
          })
        end,
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "junegunn/fzf.vim",
    dependencies = {
      "junegunn/fzf"
    },
    config = function ()
      vim.cmd[[
        let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
      ]]

      vim.keymap.set("n", "<leader>bl", ":Buffers<CR>")
      vim.keymap.set("n", "<leader>a", ":Ag<CR>", { desc = "fzf: AG", noremap = true, silent = true })
      vim.keymap.set("n", "<C-p>", ":Files<CR>", { desc = "fzf: Files", noremap = true, silent = true })
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function ()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc = "Next hunk" })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true, desc = "Prev hunk" })

          -- Actions
          map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = "Gitsigns: Stage hunk" })
          map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = "Gitsigns: Reset hunk" })
          map('n', '<leader>hS', gs.stage_buffer, { desc = "Gitsigns: Stage buffer" })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Gitsigns: undo stage hunk" })
          map('n', '<leader>hR', gs.reset_buffer, { desc = "Gitsigns: reset buffer" })
          map('n', '<leader>hp', gs.preview_hunk, { desc = "Gitsigns: preview hunk" })
          map('n', '<leader>hb', function() gs.blame_line{full=true} end, { desc = "Gitsigns: blame line" })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Gitsigns: toggle current line blame" })
          map('n', '<leader>hd', gs.diffthis, { desc = "Gitsigns: diffthis" })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Gitsigns: diffthis ~" })
          map('n', '<leader>td', gs.toggle_deleted, { desc = "Gitsigns: toggle deleted" })

          -- Text object
          -- map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end
  },
  {
    "nvimdev/lspsaga.nvim",
    config = function ()
      require("lspsaga").setup({
        lightbulb = {
          enable = false,
        },
      })

      -- Toggle outline
      vim.keymap.set("n","<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "Lspsaga: outline" })

      -- Rename
      vim.keymap.set("n","<leader>gr", "<cmd>Lspsaga rename<CR>", { desc = "Lspsaga: rename" })

      -- Code action
      vim.keymap.set({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Lspsaga: code_action"})

      vim.keymap.set({"n","t"}, "<leader>tt", "<cmd>Lspsaga term_toggle<CR>", { desc = "Lspsaga: term_toggle" })
    end
  },
  {
    "ggandor/leap.nvim",
    config = function ()
      -- local leap = require('leap')
      -- Conflics with mini.surround mappings
      -- leap.add_default_mappings()

      vim.keymap.set({'n', 'x', 'o'}, '<leader>s', '<Plug>(leap-forward-to)', { desc = "Leap forward" })
      vim.keymap.set({'n', 'x', 'o'}, '<leader>S', '<Plug>(leap-backward-to)', { desc = "Leap backward" })
      vim.keymap.set({'n', 'x', 'o'}, 'gs', '<Plug>(leap-from-window)', { desc = "Leap Leap untill" })

    end
  },
  { "romainl/vim-cool" },
  { "mattn/emmet-vim" },
  {
    'ThePrimeagen/harpoon',
    config = function ()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "Harpoon: add file" })
      vim.keymap.set("n", "<leader>hh", ui.toggle_quick_menu, { desc = "Harpoon: toggle quick menu" })

      vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
      vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
      vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
      vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)
      vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end)
    end
  },
  { 'elmar-hinz/vim.typoscript' },
  { 'mg979/vim-visual-multi' },
  -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth' },
  -- Database query in vim:
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- vim.g.db_ui_show_help = 0
      -- vim.g.db_ui_win_position = 'right'
      -- vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "leath-dub/snipe.nvim",
    config = function()
      local snipe = require("snipe")
      snipe.setup()
      vim.keymap.set("n", "gb", snipe.open_buffer_menu)
    end
  },
  {
    "oysandvik94/curl.nvim",
    -- cmd = { "CurlOpen" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function ()
      local curl = require("curl")
      curl.setup({})

      vim.keymap.set("n", "<leader>cc", function() curl.open_curl_tab() end, { desc = "Open a curl tab scoped to the current working directory" })
      vim.keymap.set("n", "<leader>cq", function() curl.close_curl_tab() end, { desc = "Close a curl tab" })
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
  {
    'stevearc/quicker.nvim',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  }
}

