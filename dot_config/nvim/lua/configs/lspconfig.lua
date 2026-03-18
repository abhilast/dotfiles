require("nvchad.configs.lspconfig").defaults()

-- DevOps and Infrastructure LSP servers
local servers = {
  "html",
  "cssls",
  "pyright",           -- Python
  "gopls",             -- Go
  "terraformls",       -- Terraform
  -- "yamlls" is configured separately in configs/yamlls.lua
  "bashls",            -- Bash
  "dockerls",          -- Docker
  "helm_ls",           -- Helm
  "jsonls",            -- JSON
  "sqls",              -- SQL
  "docker_compose_language_service", -- Docker Compose
}

-- Enable servers with default config (only if installed)
for _, lsp in ipairs(servers) do
  pcall(function()
    vim.lsp.enable(lsp)
  end)
end

-- Python specific configuration
-- Helper function to get pipenv python path from a specific directory
local function get_python_path(workspace)
  local cwd = workspace or vim.fn.getcwd()

  -- Try pipenv first (run in the workspace directory)
  local cmd = string.format("cd '%s' && pipenv --venv 2>/dev/null", cwd)
  local handle = io.popen(cmd)
  if handle then
    local venv_path = handle:read("*a"):gsub("%s+", "")
    handle:close()
    if venv_path ~= "" and venv_path ~= "nil" then
      local python_path = venv_path .. "/bin/python"
      -- Verify the python executable exists
      if vim.fn.filereadable(python_path) == 1 then
        return python_path
      end
    end
  end

  -- Fallback to system python
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

vim.lsp.config("pyright", {
  on_new_config = function(config, root_dir)
    -- Dynamically set python path based on workspace root
    local python_path = get_python_path(root_dir)
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = python_path
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic"
      }
    }
  }
})

-- Go specific configuration
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
})

-- Terraform configuration
vim.lsp.config("terraformls", {
  filetypes = { "terraform", "hcl" },
})

-- JSON configuration
vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = (function()
        local ok, schemastore = pcall(require, 'schemastore')
        if ok then
          return schemastore.json.schemas()
        else
          return {}
        end
      end)(),
      validate = { enable = true },
    },
  },
})

-- SQL LSP configuration
vim.lsp.config("sqls", {
  settings = {
    sqls = {
      connections = {
        {
          driver = "mysql",
          -- Use environment variable: export DB_MYSQL_DSN="root:YOUR_PASSWORD@tcp(127.0.0.1:3306)/dbname"
          dataSourceName = vim.fn.getenv("DB_MYSQL_DSN") ~= vim.NIL and vim.fn.getenv("DB_MYSQL_DSN") or "",
        },
        {
          driver = "postgresql",
          -- Use environment variable: export DB_POSTGRES_DSN="host=127.0.0.1 port=5432 user=postgres password=YOUR_PASSWORD dbname=dbname sslmode=disable"
          dataSourceName = vim.fn.getenv("DB_POSTGRES_DSN") ~= vim.NIL and vim.fn.getenv("DB_POSTGRES_DSN") or "",
        },
      },
    },
  },
})

-- Docker LSP configuration
vim.lsp.config("dockerls", {
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = true,
        },
      },
    },
  },
})

-- YAML Language Server is configured separately
-- See configs/yamlls.lua for the configuration
require("configs.yamlls").setup()
