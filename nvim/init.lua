-- ============================================
--  Neovim Config - Clean & Ergonomic Defaults
-- ============================================

-- Leader key (space is the most ergonomic choice)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

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
