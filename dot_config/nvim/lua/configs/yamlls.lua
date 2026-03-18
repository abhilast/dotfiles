-- Simplified YAML Language Server configuration with Kubernetes support
local M = {}

function M.setup()
  -- YAML Language Server with Kubernetes schemas
  vim.lsp.config("yamlls", {
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
    settings = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
      yaml = {
        keyOrdering = false,
        format = {
          enable = true,
        },
        validate = true,
        schemaStore = {
          -- Enable schema store for better auto-detection
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemas = {
          -- Kubernetes
          ["kubernetes"] = {"*kubernetes*.yaml", "*istiooperator*.yaml"},
          -- Istio
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/networking/v1alpha3/virtualservice.json"] = "*virtualservice*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/networking/v1alpha3/gateway.json"] = "*gateway*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/networking/v1alpha3/serviceentry.json"] = "*serviceentry*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/networking/v1alpha3/destinationrule.json"] = "*destinationrule*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/networking/v1alpha3/envoyfilter.json"] = "*envoyfilter*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/networking/v1alpha3/sidecar.json"] = "*sidecar*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/networking/v1alpha3/workloadentry.json"] = "*workloadentry*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/networking/v1alpha3/workloadgroup.json"] = "*workloadgroup*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/security/v1beta1/authorizationpolicy.json"] = "*authorizationpolicy*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/security/v1beta1/requestauthentication.json"] = "*requestauthentication*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/security/v1beta1/peerauthentication.json"] = "*peerauthentication*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/telemetry/v1alpha1/telemetry.json"] = "*telemetry*.yaml",
          ["https://raw.githubusercontent.com/istio/api/master/jsonschema/schemas/istio/extensions/v1alpha1/wasmplugin.json"] = "*wasmplugin*.yaml",
        },
        completion = true,
        hover = true,
      },
    },
  })

  vim.lsp.enable("yamlls")
end

return M
