-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    {
      'windwp/nvim-ts-autotag',
      event = 'InsertEnter',
      opts = {
        -- Enable for these filetypes
        filetypes = {
          'html',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'jsx',
          'tsx',
          'xml',
          'markdown',
        },
      },
    },
  },
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('spectre').setup()
    end,
  },
  -- {
  --   'sindrets/diffview.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('diffview').setup {
  --       enhanced_diff_hl = true, -- Better syntax highlighting in diffs
  --       view = {
  --         default = {
  --           layout = 'diff2_horizontal', -- Side-by-side layout
  --         },
  --         merge_tool = {
  --           layout = 'diff3_horizontal', -- 3-way diff for merges
  --         },
  --       },
  --     }
  --
  --     -- Keymaps for diffview
  --     vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = '[G]it [D]iff view' })
  --     vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<CR>', { desc = '[G]it diff [C]lose' })
  --     vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>', { desc = '[G]it [H]istory (all)' })
  --     vim.keymap.set('n', '<leader>gf', '<cmd>DiffviewFileHistory %<CR>', { desc = '[G]it [F]ile history (current)' })
  --     vim.keymap.set('v', '<leader>gf', "<Esc><cmd>'<,'>DiffviewFileHistory<CR>", { desc = '[G]it [F]ile history (selection)' })
  --   end,
  -- },
  -- {
  --   'akinsho/git-conflict.nvim',
  --   version = '*',
  --   config = function()
  --     require('git-conflict').setup {
  --       default_mappings = true, -- Enable default key mappings
  --       default_commands = true, -- Enable default commands
  --       disable_diagnostics = false, -- Show diagnostics for conflicts
  --       list_opener = 'copen', -- Command to open quickfix list
  --       highlights = {
  --         incoming = 'DiffAdd',
  --         current = 'DiffText',
  --       },
  --     }
  --
  --     -- Key mappings (these are the defaults, but listed here for reference):
  --     -- co — choose ours (current changes)
  --     -- ct — choose theirs (incoming changes)
  --     -- cb — choose both
  --     -- c0 — choose none
  --     -- ]x — next conflict
  --     -- [x — previous conflict
  --
  --     -- Additional keymaps
  --     vim.keymap.set('n', '<leader>gx', '<cmd>GitConflictListQf<CR>', { desc = '[G]it conflicts - List all' })
  --   end,
  -- },
}
