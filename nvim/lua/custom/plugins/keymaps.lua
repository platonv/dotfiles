-- Personal keymaps on top of kickstart. Telescope is already set up in init.lua (section 5).
--
-- Discoverability:
--   <leader>?       searchable list of ALL keymaps (Telescope), with descriptions
--   press <leader>  and wait: which-key pops up the next keys and groups
--   in Telescope:   <C-/> (insert) or ? (normal) shows the picker's own keys
--
-- Every mapping here needs a `desc` so it shows up in both of those.

local map = vim.keymap.set
local builtin = require 'telescope.builtin'

-- ---------- Find (the three main ones) ----------
map('n', '<leader>p', function()
  builtin.find_files { hidden = true, file_ignore_patterns = { '^%.git/' } }
end, { desc = 'Find files ([P]roject)' })

map('n', '<leader>f', builtin.live_grep, { desc = '[F]ind text in project (grep)' })
map('v', '<leader>f', builtin.grep_string, { desc = '[F]ind selection in project' })

-- Symbols of the current file: LSP when a server supports it, otherwise Treesitter.
map('n', '<leader>o', function()
  if #vim.lsp.get_clients { bufnr = 0, method = 'textDocument/documentSymbol' } > 0 then
    builtin.lsp_document_symbols()
  else
    builtin.treesitter()
  end
end, { desc = 'Symbols in file ([O]utline)' })
map('n', '<leader>O', builtin.lsp_dynamic_workspace_symbols, { desc = 'Symbols in w[O]rkspace (LSP)' })

map('n', '<leader>?', builtin.keymaps, { desc = '[?] Search all keymaps' })

-- ---------- Editing ----------
map('n', '<leader>w', '<Cmd>write<CR>', { desc = '[W]rite (save) file' })
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', silent = true })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', silent = true })
map('v', '<', '<gv', { desc = 'Indent left, keep selection' })
map('v', '>', '>gv', { desc = 'Indent right, keep selection' })

-- Keep the cursor centred when jumping around
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centred)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centred)' })
map('n', 'n', 'nzzzv', { desc = 'Next match (centred)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous match (centred)' })

-- ---------- Buffers & windows ----------
-- Buffer cycling: built-in [b / ]b. Window moves: C-h/j/k/l (vim-tmux-navigator).
map('n', '<leader>bd', '<Cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
map('n', '<leader>bo', '<Cmd>%bdelete|edit#|bdelete#<CR>', { desc = '[B]uffer: close [O]thers' })
-- Same split keys as tmux: | or \ splits right, - splits down
map('n', '<leader>|', '<Cmd>vsplit<CR>', { desc = 'Split right' })
map('n', '<leader>\\', '<Cmd>vsplit<CR>', { desc = 'Split right' })
map('n', '<leader>-', '<Cmd>split<CR>', { desc = 'Split down' })

-- which-key groups for the prefixes above (kickstart's init.lua defines s/t/h/gr)
require('which-key').add {
  { '<leader>b', group = '[B]uffer' },
  { '<leader>c', group = '[C]ode', mode = { 'n', 'v' } },
}
