---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  single_file_support = true,
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
}
