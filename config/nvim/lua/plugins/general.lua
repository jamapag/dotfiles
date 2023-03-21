return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, config = function ()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function ()
      require('mini.bufremove').setup({})
      require('mini.pairs').setup({})
      require("mini.cursorword").setup({})
      require("mini.surround").setup({})
      require("mini.comment").setup({})
      require("mini.statusline").setup({})
      require("mini.trailspace").setup({})
      require("mini.splitjoin").setup({})

      vim.keymap.set("n", "<leader>bd", ":lua MiniBufremove.wipeout()<CR>")
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
      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = false })
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = false })
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = false })
      vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = false })
    end
  },
  { "christoomey/vim-tmux-navigator" },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function ()
      local go_cd = function(node)
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
      end

      local list = {
        { key = "gcd", action = "print_path", action_cb = go_cd },
        { key = "s", action = "vsplit" },
        { key = "gs", action = "system_open" },
      }

      require("nvim-tree").setup({
        update_focused_file = {
          enable = true,
        },
        view = {
          mappings = {
            list = list,
          },
        },
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
  { "kshenoy/vim-signature" },
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
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
        "help",
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
    config = function ()
      require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = true,
      }
    end
  },
  {
    "hrsh7th/nvim-cmp",
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
        -- completion = {
        --   autocomplete = true,
        -- },
        snippet = {
          expand = function (args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<C-e>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
          ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'async_clj_omni' },
          {
            name = 'buffer',
            option = {
              get_bufnrs = function ()
                return vim.api.nvim_list_bufs()
              end
            },
          },
          { name = 'vsnip' },
          { name = 'path' }
        })
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
          "rust_analyzer",
          "phpactor",
          "cssls",
          "html",
          "tsserver",
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
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        --buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        --buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
          vim.inspect(vim.lsp.buf.list_workspace_folders())
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts)
        vim.keymap.set('n', '<leader>df', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '<leader>dl', "<cmd>Telescope diagnostics<cr>", opts)

        vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
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
  { "prettier/vim-prettier" },
  {
    "junegunn/fzf.vim",
    dependencies = {
      "junegunn/fzf"
    },
    config = function ()
      vim.cmd[[
        let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
      ]]

      vim.keymap.set("n", "<leader>b", ":Buffers<CR>")
      vim.keymap.set("n", "<leader>a", ":Ag<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<C-p>", ":Files<CR>", { noremap = true, silent = true })
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
          end, {expr=true})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Actions
          map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)

          -- Text object
          -- map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end
  },
  {
    "glepnir/lspsaga.nvim",
    config = function ()
      require("lspsaga").setup({})

      -- Toggle outline
      vim.keymap.set("n","<leader>o", "<cmd>Lspsaga outline<CR>")

      -- Rename
      vim.keymap.set("n","<leader>gr", "<cmd>Lspsaga rename<CR>")

      -- Code action
      vim.keymap.set({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

      vim.keymap.set({"n","t"}, "<leader>tt", "<cmd>Lspsaga term_toggle<CR>")
    end
  },
  {
    "ggandor/leap.nvim",
    config = function ()
      -- local leap = require('leap')
      -- Conflics with mini.surround mappings
      -- leap.add_default_mappings()

      vim.keymap.set({'n', 'x', 'o'}, 'f', '<Plug>(leap-forward-to)')
      vim.keymap.set({'n', 'x', 'o'}, 'F', '<Plug>(leap-backward-to)')

    end
  },
  { "romainl/vim-cool" },
  { "mattn/emmet-vim" },
  { "dart-lang/dart-vim-plugin" },
  { "akinsho/flutter-tools.nvim",
      dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function ()
      local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lsp_attach = function(client, bufnr)
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
          vim.inspect(vim.lsp.buf.list_workspace_folders())
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts)
        vim.keymap.set('n', '<leader>df', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '<leader>dl', "<cmd>Telescope diagnostics<cr>", opts)

        vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting, {})
      end
      require("flutter-tools").setup{
        lsp = {
          on_attach = lsp_attach,
          capabilities = lsp_capabilities
        }
      }
    end
  },
}

