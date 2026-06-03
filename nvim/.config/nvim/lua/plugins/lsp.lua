-- Central LSP configuration.
-- Servers are installed automatically via Mason on first launch.
-- Java is handled by nvim-jdtls (requires Java 17+ on PATH).
-- C# (omnisharp) requires .NET SDK on PATH.

local on_attach = function(_, buf)
    local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = buf, desc = desc })
    end
    map("gd",         vim.lsp.buf.definition,    "Go to Definition")
    map("gr",         vim.lsp.buf.references,    "Go to References")
    map("gi",         vim.lsp.buf.implementation,"Go to Implementation")
    map("K",          vim.lsp.buf.hover,         "Hover")
    map("<leader>rn", vim.lsp.buf.rename,        "Rename")
    map("<leader>ca", vim.lsp.buf.code_action,   "Code Action")
    map("[d",         vim.diagnostic.goto_prev,  "Prev Diagnostic")
    map("]d",         vim.diagnostic.goto_next,  "Next Diagnostic")
    map("<leader>d",  vim.diagnostic.open_float, "Diagnostic Float")
end

return {
    { "neovim/nvim-lspconfig" },
    { "mfussenegger/nvim-jdtls" },
    { "williamboman/mason.nvim", build = ":MasonUpdate", opts = {} },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "saghen/blink.cmp",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "omnisharp", -- C#
                    "pyright",   -- Python
                    "jdtls",     -- Java (handled below via nvim-jdtls)
                    "html",      -- HTML
                    "cssls",     -- CSS
                    "ts_ls",     -- JavaScript / TypeScript
                    "gopls",     -- Go
                    "bashls",    -- Bash / Shell
                },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            on_attach = on_attach,
                            capabilities = capabilities,
                        })
                    end,
                    -- Java is started per-project by the FileType autocmd below
                    jdtls = function() end,
                },
            })

            -- Java: nvim-jdtls manages a separate jdtls instance per project root
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = function()
                    local jdtls = require("jdtls")
                    local workspace = vim.fn.stdpath("data")
                        .. "/jdtls-workspace/"
                        .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
                    jdtls.start_or_attach({
                        cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
                        root_dir = jdtls.setup.find_root({
                            ".git", "mvnw", "gradlew", "pom.xml", "build.gradle",
                        }),
                        settings = { java = {} },
                        init_options = { bundles = {} },
                        capabilities = capabilities,
                        on_attach = on_attach,
                        data = workspace,
                    })
                end,
            })
        end,
    },
}
