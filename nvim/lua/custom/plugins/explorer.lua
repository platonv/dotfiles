-- File explorer: neo-tree, always docked on the RIGHT.
--   <leader>e   toggle the explorer and reveal the current file
--   inside it:  ? shows every neo-tree key (a add, d delete, r rename, H toggle hidden, ...)
-- `nvim .` / `:e some/dir` open neo-tree in place of netrw.

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '3' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('neo-tree').setup {
  close_if_last_window = true, -- quit nvim instead of leaving a lone tree window
  popup_border_style = 'rounded',
  window = {
    position = 'right',
    width = 35,
  },
  filesystem = {
    follow_current_file = { enabled = true }, -- highlight the file of the current buffer
    use_libuv_file_watcher = true, -- refresh on external changes (git checkout, etc.)
    hijack_netrw_behavior = 'open_current',
    filtered_items = {
      visible = true, -- show hidden/ignored files, dimmed, instead of hiding them
      hide_dotfiles = false,
      hide_gitignored = true,
      never_show = { '.git', '.DS_Store' },
    },
  },
}

vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle reveal right<CR>', { desc = 'File [E]xplorer (toggle)', silent = true })
