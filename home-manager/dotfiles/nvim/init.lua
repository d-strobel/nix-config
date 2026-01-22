vim.g.mapleader = " "
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  performance = {
    reset_packpath = false,
    rtp = {
      reset = false,
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    }
  },
  dev = {
    path = "/nix/store/zsp5y16m04x8ifmm237qg158x713mzh2-vim-pack-dir/pack/myNeovimPackages/start",
    patterns = { "" },
  },
  install = {
    missing = false,
  },
  ui = { border = "single" },
})

vim.cmd("colorscheme alabaster")
