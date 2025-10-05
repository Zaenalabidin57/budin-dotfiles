-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "clangd", "texlab", "pylsp", "angularls", "zls", "tinymist", "bashls", "intelephense"}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

lspconfig.html.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "html", "blade" },
}


-- typescript
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}
lspconfig.pylsp.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "python" },
}

lspconfig.tinymist.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "typst" },
  settings = {
    exportPdf = "onType",
    serverPath = "/usr/bin/tinymist",
  },
}
lspconfig.texlab.setup {
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
}
lspconfig.fish_lsp.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { 'fish-lsp', 'start' }, -- As specified in the documentation you found
  settings = {
    -- 'fish_lsp_show_client_popups' is an initialization option for fish-lsp
    -- It should be a boolean value.
    fish_lsp_show_client_popups = false,
  },
  filetypes = { "fish" }, -- Ensures it attaches to fish files
}
