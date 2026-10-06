return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                -- -- Automatically applies Kubernetes schemas to typical manifest patterns
                -- kubernetes = {
                --   "*.yaml",
                --   "*.yml",
                --   "deployment.k8s.yaml",
                --   "pod.k8s.yaml",
                --   "secret.k8s.yaml",
                -- },
              },
            },
          },
        },
      },
    },
  },
}
