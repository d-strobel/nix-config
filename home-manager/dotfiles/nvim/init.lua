-----------------------------
--: Plugins
-----------------------------
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig.git" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/dchinmay2/alabaster.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/laytan/cloak.nvim" },
  { src = "https://github.com/mohseenrm/marko.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
})
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd('nvim.difftool')

-----------------------------
--: Options
-----------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes:1"
vim.opt.confirm = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.inccommand = "split"
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 20
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.winborder = 'single'
vim.opt.path:append('**')
vim.opt.wildoptions:append { 'fuzzy' }
vim.opt.complete = 'o,.,w,b,u'
vim.opt.completeopt = 'menuone,popup,noinsert,noselect,fuzzy'
vim.opt.autocomplete = true
vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case'

-- Non-Local systems
if not vim.tbl_contains({ 'noxus', 'piltover' }, vim.loop.os_gethostname()) then
  vim.global.clipboard = "osc52"
end

-----------------------------
--: Keymaps
-----------------------------
vim.keymap.set('i', '<C-j>', '<Down>', { silent = true })              -- Map Down to CTRL-J
vim.keymap.set('i', '<C-k>', '<Up>', { silent = true })                -- Map Up to CTRL-K
vim.keymap.set('i', '<C-l>', '<C-y>', { silent = true })               -- Map Accept to CTRL-L
vim.keymap.set('i', '<C-l>', '<C-y>', { silent = true })               -- Map Accept to CTRL-L
vim.keymap.set('c', '<C-j>', '<C-n>', { silent = true })               -- Map Down to CTRL-J
vim.keymap.set('c', '<C-k>', '<C-p>', { silent = true })               -- Map Up to CTRL-K
vim.keymap.set('c', '<C-l>', '<CR>', { silent = true })                -- Map Accept to CTRL-L
vim.keymap.set('n', '<ESC>', '<CMD>nohlsearch<CR>', { silent = true }) -- Remove highlight search
vim.keymap.set("n", "<Space>", "<Nop>")                                -- Disable space in normal mode
vim.keymap.set("v", "<", "<gv")                                        -- keep visual selection when (de)indenting
vim.keymap.set("v", ">", ">gv")                                        -- keep visual selection when (de)indenting
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })        -- Move multilines in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })        -- Move multilines in visual mode
vim.keymap.set("n", "<C-d>", "<C-d>zz")                                -- Centralize while going page up and down
vim.keymap.set("n", "<C-u>", "<C-u>zz")                                -- Centralize while going page up and down
vim.keymap.set("x", "<leader>p", [["_dP]])                             -- Void registry pasting
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])                     -- Copy to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])                              -- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])                     -- Paste from system clipboard
vim.keymap.set("n", "<leader>P", [["+P]])                              -- Paste from system clipboard
vim.keymap.set("v", "p", '"_dp')                                       -- Paste over selected text without yanking it
vim.keymap.set("v", "P", '"_dP')                                       -- Paste over selected text without yanking it
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])                     -- Delete to void registry
vim.keymap.set("n", "<leader>sr", ":%s/")                              -- Search and replace in current file (n)
vim.keymap.set("v", "<leader>sr", "y:%s/<C-r>\"")                      -- Search and replace in current file (v)
vim.keymap.set("n", "<leader>qr", ":cdo s/")                           -- Quickfix search and replace
vim.keymap.set("n", "<leader>qq", "<cmd>copen<CR>")                    -- Quickfix list open
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>")                   -- Quickfix list open
vim.keymap.set('n', '<M-n>', '<cmd>cnext<CR>zz')                       -- Quickfix next
vim.keymap.set('n', '<M-p>', '<cmd>cprev<CR>zz')                       -- Quickfix next
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree)                     -- Toggle Undotree
vim.keymap.set("n", "<leader>gs", "<CMD>Git<CR>")                      -- Git Status
vim.keymap.set("n", "<leader>gc", "<CMD>Git commit<CR>")               -- Git Commit
vim.keymap.set("n", "<leader>gp", "<CMD>Git push<CR>")                 -- Git Push

-----------------------------
--: Colorscheme
-----------------------------
vim.cmd.colorscheme "alabaster"

-----------------------------
--: Filetypes
-----------------------------
vim.filetype.add({
  extension = {
    -- OpenTofu
    tf = "terraform",
    tfvars = "terraform-vars",
    tofu = "terraform",
    tofuvars = "terraform-vars",
    tfbackend = "config",
    tfstate = "json",
    -- Systemd
    service = "systemd",
    timer = "systemd",
  }
})

-----------------------------
--: Treesitter
-----------------------------
require('nvim-treesitter.config').setup {
  ensure_installed = { "python", "c", "lua", "vim", "vimdoc", "yaml", "xml", "typst", "typescript", "toml", "tmux", "terraform", "ssh_config", "rust", "regex", "python", "promql", "nix", "nginx", "markdown-inline", "markdown", "make", "lua", "latex", "java", "just", "json", "kdl", "ini", "hyprlang", "html", "helm", "hcl", "gosum", "gomod", "go", "gitignore", "gitcommit", "fish", "editorconfig", "dockerfile", "csv", "css", "c", "bash", "astro" },
  install_dir = vim.fn.stdpath('data') .. '/site',
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-----------------------------
--: Oil Explorer
-----------------------------
require("oil").setup({
  default_file_explorer = true,
  use_default_keymaps = false,
  keymaps = {
    ["<CR>"] = "actions.select",
    ["<C-l>"] = "actions.select",
    ["<Esc>"] = { "actions.close", mode = "n" },
    ["<leader>e"] = { "actions.parent", mode = "n" },
  },
  columns = { "mtime" },
  view_options = { show_hidden = true },
  skip_confirm_for_simple_edits = true,
})
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>")

-----------------------------
--: Fzf
-----------------------------
require('fzf-lua').setup({
  winopts = { preview = { horizontal = "right:40%" } },
  files = { cwd_prompt = false },
  marks = { marks = "[A-Z]", actions = { ["ctrl-l"] = FzfLua.actions.goto_mark } },
  fzf_colors = true,
  actions = {
    files = {
      ["enter"]  = FzfLua.actions.file_edit_or_qf,
      ["ctrl-l"] = FzfLua.actions.file_edit_or_qf,
      ["alt-q"]  = FzfLua.actions.file_sel_to_qf,
    },
  },
})
vim.keymap.set("n", "<leader>ff", FzfLua.files)
vim.keymap.set("n", "<leader>fg", FzfLua.live_grep)
vim.keymap.set("n", "<leader>fb", FzfLua.buffers)
vim.keymap.set("n", "<leader>fm", FzfLua.marks)

-----------------------------
--: Marks
-----------------------------
require('marko').setup({})

-- Always do uppercase and backtick marks
local prefixes = "m'"
local letters = "abcdefghijklmnopqrstuvwxyz"
for i = 1, #prefixes do
  local prefix = prefixes:sub(i, i)
  local action_prefix = ""
  if prefix == "'" then
    action_prefix = "`"
  else
    action_prefix = prefix
  end
  for j = 1, #letters do
    local lower_letter = letters:sub(j, j)
    local upper_letter = string.upper(lower_letter)
    vim.keymap.set({ "n", "v" }, prefix .. lower_letter, action_prefix .. upper_letter)
  end
end

-----------------------------
--: Cloak
-----------------------------
require("cloak").setup({
  enabled = true,
  cloak_character = "*",
  highlight_group = "Comment",
  patterns = {
    {
      file_pattern = {
        ".env*",
      },
      cloak_pattern = "=.+"
    },
  }
})

-----------------------------
--: Auotcommands
-----------------------------

-- Statusline
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    vim.wo.statusline = '[%{toupper(mode())}] %= %<%t %h%w%m%r %= [%l,%c] %{&fileencoding} | %{&filetype}'
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    vim.wo.statusline = '%= %<%t %h%w%m%r %='
  end,
})

-- Highlight yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- LSP Configuration
local autocmd_group_lsp = 'my.lsp'
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup(autocmd_group_lsp, {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Keymaps
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)

    -- Completion
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf)
    end

    -- Document Color
    if client:supports_method('textDocument/documentColor') then
      vim.lsp.document_color.enable(true, nil, { style = 'virtual' })
    end

    -- Auto-format on save.
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = autocmd_group_lsp,
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    -- Inlay hints
    if client:supports_method("textDocument/inlayHint") then
      -- Enable by default
      vim.lsp.inlay_hint.enable(true)

      -- Keymap for toggle
      vim.keymap.set("n", '<leader>ih', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "Toggle LSP inlay hints" })
    end

    -- Organize Imports
    if client:supports_method("textDocument/codeAction") then
      -- Auto organize imports for all go code
      if vim.bo.filetype == "go" then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = autocmd_group_lsp,
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.code_action {
              context = {
                only = { "source.organizeImports" },
                diagnostics = vim.diagnostic.get(),
                triggerKind = 2,
              },
              apply = true,
            }
          end
        })
      end
    end
  end,
})

-- LSP configs
vim.lsp.config("md_lsp", {
  cmd = { "md-lsp" },
  filetypes = { "markdown" },
  root_markers = { ".git" },
  single_file_support = true,
})

vim.lsp.config("tofu_ls", {
  settings = {
    filetypes = { 'terraform', 'terraform-vars' },
    root_markers = { '.terraform', '.tofu', '.git' },
  }
})

vim.lsp.config("nixd", {
  settings = { nixd = { formatting = { command = { "alejandra" } } } }
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
      signatureHelp = { enabled = true },
      telemetry = { enabled = false },
      workspace = {
        library = vim.tbl_extend(
          "keep",
          { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
          vim.api.nvim_get_runtime_file("", true)
        ),
      },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemas = {
        -- Kubernetes
        kubernetes = "*.manifest.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
        "*flow*.{yml,yaml}",

        -- Github
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["https://json.schemastore.org/dependabot-2.0"] = ".github/dependabot.{yml,yaml}",

        -- Gitlab
        ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] =
        "*gitlab-ci*.{yml,yaml}",

        -- Azure
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] =
        "azure-pipelines*.{yml,yaml}",

        -- Ansible
        ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks"] =
        "tasks/*.{yml,yaml}",
        ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] =
        "*{play,site}*.{yml,yaml}",

        -- OpenAPI
        ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
        "*api*.{yml,yaml}",

        -- Docker
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
        "*docker-compose*.{yml,yaml}",

        -- Go
        ["https://golangci-lint.run/jsonschema/golangci.jsonschema.json"] = ".golangci.{yml,yaml}",
        ["https://goreleaser.com/static/schema.json"] = ".goreleaser.{yml,yaml}",

        -- Prometheus
        ["https://json.schemastore.org/prometheus.json"] = "prometheus.{yml.yaml}",
        ["https://json.schemastore.org/prometheus.rules.json"] = "*.rules.{yml,yaml}",
        ["https://json.schemastore.org/prometheus.rules.test.json"] = "*.tests.{yml,yaml}",
      },
      redhat = { telemetry = { enabled = false } },
    },
  },
})
