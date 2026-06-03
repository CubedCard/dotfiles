return {
    { "ellisonleao/gruvbox.nvim", priority = 1000 },

    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "gruvbox",
                component_separators = "|",
                section_separators = "",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add    = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
            },
        },
    },
}
