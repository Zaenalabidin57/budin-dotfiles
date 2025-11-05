-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- lsps with default config
vim.lsp.start({
  name = "cssls",
  cmd = { "css-languageserver", "--stdio" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.start({
  name = "clangd",
  cmd = { "clangd" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.start({
  name = "angularls",
  cmd = { "angular-language-server", "--stdio" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.start({
  name = "zls",
  cmd = { "zls" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.start({
  name = "bashls",
  cmd = { "bash-language-server", "start" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.start({
  name = "intelephense",
  cmd = { "intelephense", "--stdio" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})

-- custom configs
vim.lsp.start({
  name = "html",
  cmd = { "html-languageserver", "--stdio" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "html", "blade" },
})


-- typescript
vim.lsp.start({
  name = "ts_ls",
  cmd = { "typescript-language-server", "--stdio" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
})
vim.lsp.start({
  name = "pylsp",
  cmd = { "pylsp" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "python" },
})

vim.lsp.start({
  name = "tinymist",
  cmd = { "tinymist" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "typst" },
  settings = {
    exportPdf = "onType",
    serverPath = "/usr/bin/tinymist",
  },
})
vim.lsp.start({
  name = "texlab",
  cmd = { "texlab" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    texlab = {
      build = {
       -- executable = "tectonic",
        executable = "pdflatex",
        onType = true,
      },
    },
  },
})
vim.lsp.start({
  name = "fish_lsp",
  cmd = { "fish-lsp", "start" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    -- 'fish_lsp_show_client_popups' is an initialization option for fish-lsp
    -- It should be a boolean value.
    fish_lsp_show_client_popups = false,
  },
  filetypes = { "fish" }, -- Ensures it attaches to fish files
})
