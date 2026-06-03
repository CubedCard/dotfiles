return {
    {
        "mistweaverco/kulala.nvim",
        ft = "http",
        keys = {
            { "<leader>rr", function() require("kulala").run() end,     desc = "Run HTTP request" },
            { "<leader>rl", function() require("kulala").run_all() end, desc = "Run all HTTP requests" },
        },
        opts = {},
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        keys = {
            { "<leader>fm", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
        },
        opts = {
            formatters_by_ft = {
                python = { "black" },
                go     = { "gofmt", "goimports" },
                java   = { "google-java-format" },
                cs     = { "csharpier" },
                sh     = { "shfmt" },
                bash   = { "shfmt" },
            },
            format_on_save = { timeout_ms = 500, lsp_fallback = true },
        },
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "black",
                "goimports",
                "google-java-format",
                "csharpier",
                "shfmt",
            },
        },
    },
}
