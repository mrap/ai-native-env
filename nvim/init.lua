-- ============================================
--  Neovim Config - Clean & Ergonomic Defaults
-- ============================================

-- Leader key (space is the most ergonomic choice)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================
--  lazy.nvim bootstrap
-- ============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
      vim.cmd.colorscheme("everforest")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        -- Keep the sidebar tracking + highlighting the current buffer's file.
        update_focused_file = { enable = true },
      })
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          -- Open the sidebar, then return the cursor to the file. This
          -- nvim-tree version's tree.open() always focuses the tree and
          -- ignores a focus opt, so we jump back to the file window
          -- explicitly (skip when launched on a directory, e.g. `nvim .`).
          require("nvim-tree.api").tree.open()
          if data.file ~= "" and vim.fn.isdirectory(data.file) == 0 then
            vim.schedule(function()
              vim.cmd("wincmd p")
            end)
          end
        end,
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          path_display = { "truncate" },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<Esc>"] = actions.close,
            },
          },
        },
      })
      telescope.load_extension("fzf")
    end,
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true,  -- don't navigate out of a zoomed tmux pane
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        },
      })
    end,
  },
})

-- -- Core Behavior --
vim.opt.swapfile = false           -- no swap files
vim.opt.backup = false             -- no backup files
vim.opt.undofile = true            -- persistent undo across sessions
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

vim.opt.clipboard = "unnamedplus"  -- use system clipboard
vim.opt.mouse = "a"               -- mouse support in all modes
vim.opt.updatetime = 250           -- faster CursorHold events
vim.opt.timeoutlen = 400           -- faster key sequence completion

-- -- Visual / UI --
vim.opt.number = true              -- line numbers
vim.opt.relativenumber = true      -- relative line numbers (fast jumps)
vim.opt.cursorline = true          -- highlight current line
vim.opt.signcolumn = "yes"         -- always show sign column (no jitter)
vim.opt.termguicolors = true       -- 24-bit color
vim.opt.showmode = false           -- mode is in statusline already
vim.opt.wrap = false               -- no line wrapping
vim.opt.scrolloff = 8              -- keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8          -- keep 8 cols left/right of cursor
vim.opt.colorcolumn = "100"        -- subtle column guide

-- -- Indentation --
vim.opt.expandtab = true           -- spaces, not tabs
vim.opt.shiftwidth = 2             -- indent width
vim.opt.tabstop = 2                -- tab display width
vim.opt.softtabstop = 2            -- tab key width
vim.opt.smartindent = true         -- auto-indent new lines

-- -- Search --
vim.opt.ignorecase = true          -- case-insensitive search...
vim.opt.smartcase = true           -- ...unless you use a capital
vim.opt.hlsearch = true            -- highlight matches
vim.opt.incsearch = true           -- show matches as you type

-- -- Splits --
vim.opt.splitbelow = true          -- horizontal splits go below
vim.opt.splitright = true          -- vertical splits go right

-- -- Completion --
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.pumheight = 10             -- max popup menu height

-- -- Whitespace rendering (subtle) --
vim.opt.list = true
vim.opt.listchars = { tab = ">> ", trail = ".", nbsp = " " }

-- -- Filetype / Syntax --
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- ============================================
--  Keymaps
-- ============================================
local map = vim.keymap.set
local opts = { silent = true }

-- Clear search highlight with Escape
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Window navigation (<C-h/j/k/l>) is handled by nvim-tmux-navigation,
-- which seamlessly crosses into tmux panes at the edges.

-- Resize splits with arrows
map("n", "<C-Up>",    "<cmd>resize +2<CR>", opts)
map("n", "<C-Down>",  "<cmd>resize -2<CR>", opts)
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Better paste (don't lose register when pasting over selection)
map("x", "p", [["_dP]], opts)

-- File tree
map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", opts)
-- Reveal & highlight the current file in the sidebar
map("n", "<leader>N", "<cmd>NvimTreeFindFile<CR>", opts)

-- Fuzzy finder
map("n", "<leader>t", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- Quick save / quit
map("n", "<leader>w", "<cmd>w<CR>", opts)
map("n", "<leader>q", "<cmd>q<CR>", opts)

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", opts)
map("n", "<S-l>", "<cmd>bnext<CR>", opts)
map("n", "<leader>bd", "<cmd>bdelete<CR>", opts)

-- Select all
map("n", "<leader>a", "ggVG", opts)

-- Stay in indent mode when indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- ============================================
--  Autocommands
-- ============================================
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight text on yank (brief flash)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Return to last edit position when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lines = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Quit Neovim when the nvim-tree file explorer is the only window left
vim.api.nvim_create_autocmd("QuitPre", {
  group = augroup,
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(tree_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= "" then
        table.insert(floating_wins, w)
      end
    end
    -- If the tree is the only non-floating window, close it so nvim exits.
    if 1 == #wins - #floating_wins - #tree_wins then
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})
