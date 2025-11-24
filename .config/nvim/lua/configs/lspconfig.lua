require("nvchad.configs.lspconfig").defaults()

-- LSP servers to enable
local servers = {
  "html",
  "cssls",
  "lua_ls",
  "stylua",
  "prettier",
  "fish_lsp",
  "bashls",
  "pylsp",
  "clangd",
  "tinymist",
  "prettier",
  "intelephense",
  "kotlin_language_server",
}

-- Server-specific configurations
local server_configs = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" }
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true)
        }
      }
    }
  },
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = { enabled = true },
          pyflakes = { enabled = true },
          mccabe = { enabled = false }
        }
      }
    }
  },
  clangd = {
    cmd = { "clangd", "--offset-encoding=utf-16" }
  },
  tinymist = {
    settings = {
      tinymist = {
        exportPdf = "onSave",
        semanticTokens = "enable",
        formatterMode = "typstyle",
        onEnter = "follow",
        completion = {
          trigger = "auto"
        },
        experimentalFormatterMode = "typstyle"
      }
    }
  }
}

-- Enable LSP servers with configurations
for _, server in ipairs(servers) do
  local config = server_configs[server] or {}
  vim.lsp.enable(server, config)
end

-- LSP key mappings
local nmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

nmap('<leader>rm', vim.lsp.buf.rename, '[R]e[n]ame')
nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

-- LSP diagnostics configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- LSP handlers for better UI
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
) 
